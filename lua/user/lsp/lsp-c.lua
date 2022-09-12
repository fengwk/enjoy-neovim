-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#bashls

local lsp_common = require "user.lsp.lsp-common"

return {
  ts = "c",
  lsp = "bashls",
  setup = function()
    require("lspconfig")["bashls"].setup({
      on_attach = function(client, bufnr)
        lsp_common.on_attach(client, bufnr)
      end,
      capabilities = lsp_common.make_capabilities(),
    })
  end
}