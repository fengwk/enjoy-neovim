-- https://github.com/voldikss/vim-translator

-- vim.keymap.set("n", "<leader>t", ":Translate --engines=haici<CR>", { noremap = true, silent = true, desc = "Translate Current Word" })
vim.keymap.set("n", "<leader>t", ":Translate --engines=google<CR>", { noremap = true, silent = true, desc = "Translate Current Word" })
vim.keymap.set("v", "<leader>t", ":Translate --engines=google<CR>", { noremap = true, silent = true, desc = "Translate Selection" })
vim.keymap.set("n", "<leader>T", function()
  local text = vim.fn.input("Translate: ")
  vim.cmd("Translate --engines=google " .. text)
end, { noremap = true, silent = true, desc = "Translate Current Word" })