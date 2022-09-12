-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#powershell_es

local lsp_common = require "user.lsp.lsp-common"

local utils = require "user.utils"

if utils.os_name == 'win' then
  return {
    lsp = "powershell_es",
    setup = function()
      require("lspconfig")["powershell_es"].setup({
        on_attach = function(client, bufnr)
          lsp_common.on_attach(client, bufnr)
        end,
        capabilities = lsp_common.make_capabilities(),
      })
    end
  }
else
  return {}
end