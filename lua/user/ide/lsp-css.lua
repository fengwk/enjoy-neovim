-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cssls

local lsp_utils = require "user.ide.lsp-utils"

return {
  lsp = "cssls",
  setup = function()
    require("lspconfig")["cssls"].setup({
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
      end,
      capabilities = lsp_utils.make_capabilities(),
    })
  end
}