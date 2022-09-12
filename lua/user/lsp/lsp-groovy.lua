-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#groovyls

local lsp_common = require "user.lsp.lsp-common"

return {
  lsp = "groovyls",
  setup = function()
    require("lspconfig")["groovyls"].setup({
      on_attach = function(client, bufnr)
        lsp_common.on_attach(client, bufnr)
      end,
      capabilities = lsp_common.make_capabilities(),
    })
  end
}