require "user.ide.mason"
require "user.ide.nvim-dap-ui"
require "user.ide.nvim-dap-virtual-text"
require "user.ide.nvim-dap"
local utils = require "user.utils"

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

-- lsp配置
local lsp_conf = {
  require("user.ide.lsp-bash"),
  require("user.ide.lsp-c"),
  require("user.ide.lsp-css"),
  require("user.ide.lsp-go"),
  require("user.ide.lsp-groovy"),
  require("user.ide.lsp-html"),
  require("user.ide.lsp-java"),
  require("user.ide.lsp-json"),
  require("user.ide.lsp-lua"),
  require("user.ide.lsp-powershell"),
  require("user.ide.lsp-python"),
  require("user.ide.lsp-sql"),
  require("user.ide.lsp-ts"),
  require("user.ide.lsp-vim"),
  require("user.ide.lsp-yaml"),
}

-- 安装需要的lsp
local ensure_installed = {}
for _, conf in ipairs(lsp_conf) do
  if conf.lsp ~= nil then
    for _, l in ipairs(utils.adapt_array(conf.lsp)) do
      table.insert(ensure_installed, l)
    end
  end
end

-- https://github.com/williamboman/mason-lspconfig.nvim
require("mason-lspconfig").setup({
  ensure_installed = ensure_installed,
  automatic_installation = true,
})

-- https://github.com/neovim/nvim-lspconfig
-- 安装所有lsp配置
for _, conf in ipairs(lsp_conf) do
  if conf.setup ~= nil then
    conf.setup()
  end
end