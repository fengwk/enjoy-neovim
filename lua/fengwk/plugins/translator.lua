-- https://github.com/voldikss/vim-translator

-- 在无法翻墙的情况下可以使用haici作为替代方案，不过haici只能翻译单词
-- vim.keymap.set("n", "<leader>t", ":Translate --engines=haici<CR>", { silent = true, desc = "Translate Current Word" })
vim.keymap.set("n", "<leader>t", ":Translate --engines=google<CR>", { silent = true, desc = "Translate Current Word" })
vim.keymap.set("v", "<leader>t", ":Translate --engines=google<CR>", { silent = true, desc = "Translate Selection" })
vim.keymap.set("n", "<leader>T", function()
  vim.ui.input({ prompt = "Translate: " }, function(input)
    vim.cmd("Translate --engines=google " .. input)
  end)
end, { silent = true, desc = "Translate Current Word" })