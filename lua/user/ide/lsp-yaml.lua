-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#yamlls

local lsp_utils = require "user.ide.lsp-utils"

return {
  lsp = "yamlls",
  setup = function()
    require("lspconfig")["yamlls"].setup({
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
      end,
      capabilities = lsp_utils.make_capabilities(),
    })
  end
}