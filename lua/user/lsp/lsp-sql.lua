-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sqls

local lsp_common = require "user.lsp.lsp-common"

return {
  ts = "sql",
  lsp = "sqls",
  setup = function()
    require("lspconfig")["sqls"].setup({
      on_attach = function(client, bufnr)
        lsp_common.on_attach(client, bufnr)
      end,
      capabilities = lsp_common.make_capabilities(),
    })
  end
}