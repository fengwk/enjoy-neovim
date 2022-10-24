require("formatter").setup({})

vim.keymap.set("n", "<leader>fm", "<Cmd>Format<CR>", { silent = true, desc = "Format" })