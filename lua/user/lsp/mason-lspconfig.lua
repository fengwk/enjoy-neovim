-- https://github.com/williamboman/mason-lspconfig.nvim

local utils = require "user.utils"

-- 构建需要安装的lsp配置
local ensure_installed = {}
for _, conf in ipairs(require("user.lsp.lsp-config")) do
  if conf.lsp ~= nil then
    for _, l in ipairs(utils.adapt_array(conf.lsp)) do
      table.insert(ensure_installed, l)
    end
  end
end

require("mason-lspconfig").setup({
  ensure_installed = ensure_installed,
  automatic_installation = true,
})