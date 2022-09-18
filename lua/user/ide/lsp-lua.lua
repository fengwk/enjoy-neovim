-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua

local lsp_utils = require "user.ide.lsp-utils"

return {
  lsp = "sumneko_lua",
  setup = function()
    require("lspconfig")["sumneko_lua"].setup({
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
      end,
      capabilities = lsp_utils.make_capabilities(),
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim", "use_rocks" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end
}