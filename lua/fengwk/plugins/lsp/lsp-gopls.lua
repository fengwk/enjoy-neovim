-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls

local utils = require "fengwk.utils"

return {
  root_dir = function()
    local parts = { "go.mod" }

    local go111module = vim.fn.system { "go", "env", "GO111MODULE" }
    if go111module ~= nil then
      go111module = vim.trim(go111module)
    end

    if go111module == "auto" or go111module == "off" then
      local gopath = vim.fn.system { "go", "env", "GOPATH" }
      if gopath ~= nil then
        gopath = vim.trim(gopath)
      end
      table.insert(parts, gopath)
    end

    return utils.fs.root_dir(parts, 1) or vim.fn.getcwd()
  end,
}
