-- https://github.com/lukas-reineke/indent-blankline.nvim

local ok, indent_blankline = pcall(require, "indent_blankline")
if not ok then
  return
end

vim.g.indent_blankline_use_treesitter = false
vim.g.indent_blankline_use_treesitter_scope = false

indent_blankline.setup({
  -- 需要treesiter支持
  show_current_context = true, -- 如果为true突出当前区域缩进线
  show_current_context_start = false, -- 如果为true突出当前区域开始位置
})