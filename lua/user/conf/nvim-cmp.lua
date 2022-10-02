-- https://github.com/hrsh7th/nvim-cmp

local cmp = require "cmp"
local lspkind = require "lspkind"
local utils = require "user.utils"

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
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
    completion = cmp.config.window.bordered(), -- 补全窗口边框
    documentation = cmp.config.window.bordered(), -- 文档窗口边框
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
    { name = "vsnip" },    -- snippets
    { name = "nvim_lsp" }, -- lsp
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
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
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