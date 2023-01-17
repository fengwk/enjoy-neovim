-- https://github.com/folke/which-key.nvim

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

local utils = require("fengwk.utils")

local config = {
  plugins = {
    marks = false, -- 使用'和`呼出which-key
    registers = false, -- nomal模式"和插入模式<C-r>时使用which-key展示registers
  },
}

-- tty环境的图标适配
if utils.is_tty() then
  config = vim.tbl_deep_extend("force", config, {
    icons = {
      breadcrumb = ">>", -- symbol used in the command line area that shows your active key combo
      separator = ">", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    }
  })
end

wk.setup(config)