-- https://github.com/gbprod/substitute.nvim

local ok, substitute = pcall(require, "substitute")
if not ok then
  return
end

substitute.setup({})

-- 替换motion区间
vim.keymap.set("n", "rs", require("substitute").operator, { noremap = true })
-- 替换整行
vim.keymap.set("n", "rss", require("substitute").line, { noremap = true })
-- 替换当前光标到行尾
vim.keymap.set("n", "rS", require("substitute").eol, { noremap = true })
-- 替换选中区间
vim.keymap.set("x", "rs", require("substitute").visual, { noremap = true })
