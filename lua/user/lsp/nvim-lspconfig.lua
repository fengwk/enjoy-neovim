-- https://github.com/neovim/nvim-lspconfig

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local keymapopts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, keymapopts)
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, keymapopts)
vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Goto Prev Diagnostic" })
vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Goto Next Diagnostic" })

-- 安装所有lsp配置
for _, conf in ipairs(require("user.lsp.lsp-config")) do
  if conf.setup ~= nil then
    conf.setup()
  end
end