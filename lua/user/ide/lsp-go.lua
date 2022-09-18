-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls

local lsp_utils = require "user.ide.lsp-utils"

return {
  lsp = "gopls",
  setup = function()
    require("lspconfig")["gopls"].setup({
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
      end,
      capabilities = lsp_utils.make_capabilities(),
    })
  end
}