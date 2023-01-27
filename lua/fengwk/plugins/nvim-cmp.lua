-- https://github.com/hrsh7th/nvim-cmp

local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end
local types = require("cmp.types")
local lspkind = require("lspkind")
local utils = require("fengwk.utils")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- 内建的比较器
local compare = cmp.config.compare

-- source比较器，使用kind比较器代替
-- local source_order = {
--   ["nvim_lsp"] = 1,
--   ["vsnip"] = 1,
--   ["path"] = 2,
--   ["buffer"] = 3,
-- }
-- local function source_sort(e1, e2)
--   local o1 = source_order[e1.source.name]
--   local o2 = source_order[e2.source.name]
--   o1 = o1 and o1 or 999
--   o2 = o2 and o2 or 999
--   if o1 < o2 then
--     return true
--   elseif o1 > o2 then
--     return false
--   end
-- end

-- kind比较器
local CompletionItemKind = types.lsp.CompletionItemKind

local kind_priority = {
  [CompletionItemKind.Snippet] = 1,
  [CompletionItemKind.Field] = 1,
  [CompletionItemKind.Property] = 1,
  [CompletionItemKind.Variable] = 1,
  [CompletionItemKind.Function] = 2,
  [CompletionItemKind.Method] = 2,
  [CompletionItemKind.Constructor] = 2,
  [CompletionItemKind.Constant] = 2,
  [CompletionItemKind.Enum] = 3,
  [CompletionItemKind.EnumMember] = 3,
  [CompletionItemKind.Event] = 3,
  [CompletionItemKind.Operator] = 3,
  [CompletionItemKind.Reference] = 3,
  [CompletionItemKind.Struct] = 3,
  [CompletionItemKind.Class] = 3,
  [CompletionItemKind.Keyword] = 3,
  [CompletionItemKind.TypeParameter] = 3,
  [CompletionItemKind.Interface] = 3,
  [CompletionItemKind.Module] = 3,
  [CompletionItemKind.Unit] = 4,
  [CompletionItemKind.File] = 4,
  [CompletionItemKind.Folder] = 4,
  [CompletionItemKind.Color] = 4,
  [CompletionItemKind.Text] = 4,
  [CompletionItemKind.Value] = 4,
}

local function get_kind_priority(e)
  local p = nil
  if e.source.name == "nvim_lsp" then
    p = kind_priority[e:get_kind()]
  elseif e.source.name == "vsnip" then
    p = kind_priority[CompletionItemKind.Snippet]
  end
  return p and p or 999
end

local function kind_sort(e1, e2)
  local p1 = get_kind_priority(e1)
  local p2 = get_kind_priority(e2)
  if p1 < p2 then
    return true
  elseif p1 > p2 then
    return false
  end
end

-- 安装cmp
cmp.setup({
  -- snippets
  snippet = {
    expand = function(args)
      -- 安装vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  -- 快捷键映射
  mapping = cmp.mapping.preset.insert({
    -- 向上滚动补全项文档
    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
    -- 向下滚动补全项文档
    ["<C-j>"] = cmp.mapping.scroll_docs(4),
    -- 关闭补全项窗口
    ["<C-e>"] = cmp.mapping.abort(),
    -- ["<Esc>"] = cmp.mapping.abort(),
    -- 确认补全项，select如果为true表示没有选项时默认选择第一个，false则不做选择进行换行
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- 下一个补全项
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it"s probably `<Tab>`.
      end
    end, { "i", "s" }),
    -- 上一个补全项
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),
  -- 窗口样式
  window = {
    -- completion = cmp.config.window.bordered(), -- 补全窗口边框
    --
    -- documentation = vim.tbl_deep_extend("force", cmp.config.window.bordered(), { -- 文档窗口边框
    --   -- max_height = 10,
    -- }),

  },
  -- 补全项格式
  formatting = utils.is_tty() and {} or {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      menu = ({
        nvim_lsp = "[Lsp]",
        vsnip = "[Vsnip]",
        buffer = "[Buffer]",
        path = "[Path]",
        cmdline = "[Cmd]",
      })
    }),
  },
  -- 实验性参数
  experimental = {
    ghost_text = false, -- 暗纹展示最有可能补全的文本
  },
  -- 补全来源
  sources = {
    {
      name = "nvim_lsp", -- lsp
      entry_filter = function(entry, _)
        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
      end,
    },
    { name = "vsnip" },    -- snippets
    { name = "path" },     -- 文件系统路
    {
      name = "buffer",     -- 缓冲区
      option = {
        get_bufnrs = function() -- 默认是vim.api.nvim_get_current_buf()
          -- 将所有缓冲区作为候选
          return vim.api.nvim_list_bufs()
          -- 将所有可见的缓冲区作为候选
          -- local bufs = {}
          -- for _, win in ipairs(vim.api.nvim_list_wins()) do
          --   bufs[vim.api.nvim_win_get_buf(win)] = true
          -- end
          -- return vim.tbl_keys(bufs)
        end
      },
    },
  },
  -- 排序方式
  sorting = {
    comparators = {
      kind_sort, -- 自定义的kind排序
      compare.offset, -- lsp给出的顺序
      compare.exact,
      -- compare.score,
      -- compare.recently_used,
      compare.locality, -- 当前缓冲区判断优先
      compare.length, -- 长度
      compare.order, -- id序，兜底
    },
  },
  -- 启用情况
  enabled = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      -- 如果是dap提示框则允许补全
      local ok_cmp_dap, cmp_dap = pcall(require, "cmp_dap")
      if ok_cmp_dap and cmp_dap.is_dap_buffer() then
        return true
      end
      -- 普通提示版禁用补全
      return false
    end
    -- 默认启用补全
    return true
  end,
})

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
-- cmp.setup.cmdline("/", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = "buffer" }
--   }
-- })

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = "cmdline" },
--     { name = "path" },
--   },
-- })