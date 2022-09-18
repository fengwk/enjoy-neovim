-- https://github.com/neovim/nvim-lspconfig

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- local keymapopts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, keymapopts)
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, keymapopts)
vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Diagnostic Prev" })
vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Diagnostic Next" })

-- telescope
-- vim.keymap.set("n", "ge", "<Cmd>lua require('telescope.builtin').diagnostics()<CR>", { noremap = true, silent = true, desc = "Lsp Diagnostics" })

-- qf
vim.keymap.set("n", "ge", vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Diagnostic Quickfix" })

-- 安装所有lsp配置
for _, conf in ipairs(require("user.ide.lsp-config")) do
  if conf.setup ~= nil then
    conf.setup()
  end
end