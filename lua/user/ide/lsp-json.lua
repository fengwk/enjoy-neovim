-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls

local lsp_utils = require "user.ide.lsp-utils"

return {
  lsp = "jsonls",
  setup = function()
    require("lspconfig")["jsonls"].setup({
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
      end,
      capabilities = lsp_utils.make_capabilities(),
    })
  end
}