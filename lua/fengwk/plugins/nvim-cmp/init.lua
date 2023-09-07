-- https://github.com/hrsh7th/nvim-cmp
local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

local types = require "cmp.types"
local lspkind = require "fengwk.plugins.nvim-cmp.lspkind"
local utils = require "fengwk.utils"

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp_fts = {
  "bash", "sh",
  "c", "cpp", "objc", "objcpp", "cuda", "proto",
  "css", "scss", "less", "go", "gomod", "gowork", "gotmpl",
  "groovy", "html", "lua", "ps1", "python",
  "javascript", "javascriptreact", "javascript.jsx",
  "typescript", "typescriptreact", "typescript.tsx",
  "vim", "yaml", "yaml.docker-compose",
  "xml", "xsd", "xsl", "xslt", "svg",
  "dockerfile", "markdown",
}

-- 内建的比较器
local compare = cmp.config.compare

-- 边框样式
local function win_border()
  return cmp.config.window.bordered({
    winhighlight = "Normal:Normal,FloatBorder:MyFloatBorder,CursorLine:Visual,Search:None"
  })
end

-- 对Snippet和nvim_lsp使用基于长度权重的比较
-- k1_w * k1_len - k2_w * k2_len
local CompletionItemKind = types.lsp.CompletionItemKind

local source_weight = {
  copilot = 0.05,
  nvim_lsp = 1,
  vsnip = 1,
  buffer = 1.5,
  path = 1.5,
  cmdline = 1.5,
}

local kind_weight = {
  [CompletionItemKind.Snippet] = 1,
  [CompletionItemKind.Field] = 1,
  [CompletionItemKind.Property] = 1,
  [CompletionItemKind.Variable] = 1,
  [CompletionItemKind.Function] = 1,
  [CompletionItemKind.Method] = 1,
  [CompletionItemKind.Keyword] = 1.5,
  [CompletionItemKind.Constructor] = 1.5,
  [CompletionItemKind.Constant] = 1.5,
  [CompletionItemKind.Enum] = 2,
  [CompletionItemKind.EnumMember] = 2,
  [CompletionItemKind.Event] = 2,
  [CompletionItemKind.Operator] = 2,
  [CompletionItemKind.Reference] = 2,
  [CompletionItemKind.Struct] = 2,
  [CompletionItemKind.Class] = 2,
  [CompletionItemKind.TypeParameter] = 2,
  [CompletionItemKind.Interface] = 2,
  [CompletionItemKind.Module] = 2,
  [CompletionItemKind.Unit] = 2.5,
  [CompletionItemKind.File] = 2.5,
  [CompletionItemKind.Folder] = 2.5,
  [CompletionItemKind.Color] = 3,
  [CompletionItemKind.Value] = 3,
  [CompletionItemKind.Text] = 3,
}

local function get_source_weight(e)
  return source_weight[e.source.name] or 1
end

local function get_kind_weight(e)
  if e.source.name == "nvim_lsp" then
    return kind_weight[e:get_kind()]
  elseif e.source.name == "vsnip" then
    return kind_weight[CompletionItemKind.Snippet]
  else
    return kind_weight[CompletionItemKind.Text]
  end
end

local function get_detail(e)
  if e.completion_item.labelDetails and e.completion_item.labelDetails.detail then
    return e.completion_item.labelDetails.detail
  end
  return ""
end

local function weight_sort(e1, e2)
  local w1 = get_kind_weight(e1) * get_source_weight(e1)
  local w2 = get_kind_weight(e2) * get_source_weight(e2)
  if w1 and w2 then
    -- 应用权重与长度
    local diff = w1 * #e1.completion_item.label - w2 * #e2.completion_item.label
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    else
      -- 如果签名长度一致，比较detail
      -- 对于jdtls而言，label中存储了方法名，detail中存储了参数签名
      local d1 = get_detail(e1)
      local d2 = get_detail(e2)
      diff = #d1 - #d2
      if diff < 0 then
        return true
      elseif diff > 0 then
        return false
      end
    end
  elseif not w1 and not w2 then
    return nil
  elseif w1 then
    return true
  else -- w2
    return false
  end
end

local function copilot_prioritize(e1, e2)
  local s1 = e1.source.name == "copilot" and 1 or 0
  local s2 = e2.source.name == "copilot" and 1 or 0
  if s1 == s2 then
    return nil
  end
  return s1 > s2
end

-- https://github.com/zbirenbaum/copilot.lua
local ok_copilot, copilot = pcall(require, "copilot")
if ok_copilot then
  copilot.setup {
    panel = {
      enabled = false,
    },
    suggestion = {
      enabled = false, -- 启用这个会影响cmp source
      auto_trigger = true,
    },
  }

  cmp.event:on("menu_opened", function()
    vim.b.copilot_suggestion_hidden = true
  end)

  cmp.event:on("menu_closed", function()
    vim.b.copilot_suggestion_hidden = false
  end)

  local ok_copilot_cmp, copilot_cmp = pcall(require, "copilot_cmp")
  if ok_copilot_cmp then
    copilot_cmp.setup()
  end
end
local types = require('cmp.types')


-- 安装cmp
cmp.setup({
  -- snippets
  snippet = {
    expand = function(args)
      -- 安装vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  completion = {
    autocomplete = { -- 指定自动补全的时机
      'InsertEnter',
      'TextChanged',
    },
  },
  -- 快捷键映射
  mapping = {
    -- 向上滚动补全项文档
    ["<C-u>"] = cmp.mapping.scroll_docs(-5),
    -- 向下滚动补全项文档
    ["<C-d>"] = cmp.mapping.scroll_docs(5),
    -- 关闭补全项窗口
    ["<C-e>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.mapping.abort()()
      elseif ok_copilot and require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").dismiss()
      else
        fallback()
      end
    end, { "i", "s" }),
    -- ["<Esc>"] = cmp.mapping.abort(),
    -- 确认补全项，select如果为true表示没有选项时默认选择第一个，false则不做选择进行换行
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- 下一个补全项
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then -- 补全已开启则选择下一项
        cmp.select_next_item()
      elseif ok_copilot and require("copilot.suggestion").is_visible() then -- 接受copilot提示
        require("copilot.suggestion").accept()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      -- elseif has_words_before() then -- 前边有单词则开启补全
      --   cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it"s probably `<Tab>`
      end
    end, { "i", "s" }),
    -- 选择上一个补全项
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      else
        fallback()
      end
    end, { "i", "s" }),
    -- 默认inert模式下<C-n>是唤出neovim自带的补全，修改为使用cmp的补全
    ["<C-n>"] = cmp.mapping(function(fallback)
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
      else
        if utils.vim.ft() == "chatgpt-input" then
          fallback()
        else
          cmp.complete()
        end
      end
    end, { "i", "s" }),
  },
  -- 窗口样式
  window = {
    completion = win_border(), -- 补全窗口边框
    documentation = win_border(), -- 文档窗口边框
  },
  -- 补全项格式
  formatting = utils.sys.is_tty() and {} or {
    format = lspkind.cmp_format({
      maxwidth = 50,
      mode = "symbol_text",
      menu = ({
        copilot = "[Copilot]",
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
    ghost_text = false, -- 暗纹展示最有可能补全的文本，与copilot冲突
  },
  -- 补全来源
  sources = {
    { name = "copilot" },
    {
      name = "nvim_lsp", -- lsp
      entry_filter = function(entry, _)
        -- 过滤lsp中返回的Text
        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
      end,
    },
    { name = "vsnip" },    -- snippets
    { name = "path" },     -- 文件系统路
    {
      name = "buffer",     -- 缓冲区
      option = {
        get_bufnrs = function() -- 默认是vim.api.nvim_get_current_buf()
          if utils.vim.ft() == "json" then
            return {}
          end

          -- -- 如果缓冲区过大，则禁用
          if utils.vim.is_large_buf() then
            return {}
          end

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
      weight_sort, -- 基于权重排序
      -- compare.offset, -- lsp给出的顺序
      -- compare.exact,
      compare.recently_used, -- 近期使用
      compare.locality, -- 当前缓冲区优先
      compare.length, -- 长度
      compare.order, -- id序，兜底

      -- copilot_prioritize,
      -- -- Below is the default comparitor list and order for nvim-cmp
      -- compare.offset,
      -- -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      -- compare.exact,
      -- compare.score,
      -- compare.recently_used,
      -- compare.locality,
      -- compare.kind,
      -- compare.sort_text,
      -- compare.length,
      -- compare.order,
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
