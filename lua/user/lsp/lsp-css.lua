-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cssls

local lsp_common = require "user.lsp.lsp-common"

return {
  ts = "css",
  lsp = "cssls",
  setup = function()
    require("lspconfig")["cssls"].setup({
      on_attach = function(client, bufnr)
        lsp_common.on_attach(client, bufnr)
      end,
      capabilities = lsp_common.make_capabilities(),
    })
  end
}