-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver

local utils = require "fengwk.utils"

return {
  root_dir = function()
    return utils.fs.root_dir {
      "package.json", "tsconfig.json", "jsconfig.json", ".git"
    } or vim.fn.getcwd()
  end
}
