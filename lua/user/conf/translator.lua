-- https://github.com/voldikss/vim-translator

vim.keymap.set("n", "<leader>t", ":Translate --engines=haici<CR>", { noremap = true, silent = true, desc = "Translate Current Word" })
vim.keymap.set("v", "<leader>t", ":Translate --engines=google<CR>", { noremap = true, silent = true, desc = "Translate Selection" })