-- https://github.com/voldikss/vim-translator

-- vim.keymap.set("n", "<leader>t", ":Translate --engines=haici<CR>", { noremap = true, silent = true, desc = "Translate Current Word" })
vim.keymap.set("n", "<leader>t", ":Translate --engines=google<CR>", { noremap = true, silent = true, desc = "Translate Current Word" })
vim.keymap.set("v", "<leader>t", ":Translate --engines=google<CR>", { noremap = true, silent = true, desc = "Translate Selection" })
vim.keymap.set("n", "<leader>T", function()
  vim.ui.input({ prompt = "Translate: " }, function(input)
    vim.cmd("Translate --engines=google " .. input)
  end)
end, { noremap = true, silent = true, desc = "Translate Current Word" })