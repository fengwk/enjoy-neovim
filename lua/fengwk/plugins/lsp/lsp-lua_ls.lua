-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua

local utils = require("fengwk.utils")

-- https://github.com/folke/neodev.nvim
local ok, neodev = pcall(require, "neodev")
if ok then
  neodev.setup()
end

return {
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
      -- neodev
      completion = {
        callSnippet = "Replace"
      },
    },
  },

  root_dir = function()
    return utils.fs.root_dir {
      "lua",
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
    }, 1 or vim.fn.getcwd()
  end,
}
