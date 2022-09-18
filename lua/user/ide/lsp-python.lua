-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright

local lsp_utils = require "user.ide.lsp-utils"

return {
  lsp = "pyright",
  setup = function()
    require("lspconfig")["pyright"].setup({
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
      end,
      capabilities = lsp_utils.make_capabilities(),
    })
  end
}