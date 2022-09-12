-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#yamlls

local lsp_common = require "user.lsp.lsp-common"

return {
  ts = "yaml",
  lsp = "yamlls",
  setup = function()
    require("lspconfig")["yamlls"].setup({
      on_attach = function(client, bufnr)
        lsp_common.on_attach(client, bufnr)
      end,
      capabilities = lsp_common.make_capabilities(),
    })
  end
}