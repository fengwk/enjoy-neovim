-- 从darkplus.nvim中复刻并修改
-- https://github.com/LunarVim/darkplus.nvim

local theme = require "user.themes.my-darkplus.theme"

local M = {}

M.setup = function()
  vim.cmd("hi clear")

  vim.o.background = "dark"
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "darkplus"

  theme.set_highlights()
end

return M