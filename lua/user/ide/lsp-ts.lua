-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver

local lsp_utils = require "user.ide.lsp-utils"

return {
  ts = { "javascript", "typescript", "vue" },
  lsp = "tsserver",
  setup = function()
    require("lspconfig")["tsserver"].setup({
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
      end,
      capabilities = lsp_utils.make_capabilities(),
    })
  end
}