-- https://github.com/gbprod/substitute.nvim

local ok, substitute = pcall(require, "substitute")
if not ok then
  return
end

substitute.setup({})

vim.keymap.set("n", "<leader>r", require("substitute").operator, { noremap = true })
vim.keymap.set("n", "<leader>rr", require("substitute").line, { noremap = true })
vim.keymap.set("n", "<leader>R", require("substitute").eol, { noremap = true })
vim.keymap.set("x", "<leader>r", require("substitute").visual, { noremap = true })
