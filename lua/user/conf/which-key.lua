-- https://github.com/folke/which-key.nvim

local wk = require("which-key")
local utils = require "user.utils"

local config = {
  plugins = {
    marks = false, -- shows a list of your marks on ' and `
    registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
  },
}

-- 处理tty环境的icnos显示
if utils.is_tty() then
  config.icons = {
    breadcrumb = ">>", -- symbol used in the command line area that shows your active key combo
    separator = ">", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  }
end

wk.setup(config)