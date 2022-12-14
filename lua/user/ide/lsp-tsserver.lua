-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver

local utils = require "user.utils"

return {
  root_dir = function()
    return utils.find_root_dir({
      "package.json", "tsconfig.json", "jsconfig.json", ".git"
    }, 1) or vim.fn.getcwd()
  end
}