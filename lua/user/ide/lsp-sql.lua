-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sqls

local lsp_utils = require "user.ide.lsp-utils"

return {
  lsp = "sqls",
  setup = function()
    require("lspconfig")["sqls"].setup({
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
      end,
      capabilities = lsp_utils.make_capabilities(),
    })
  end
}