-- lualine的nightfly主题
local function lualine_nightfly()
  local lualine_nightfly = require("lualine.themes.nightfly")
  local new_colors = {
    blue = "#56D1FF",
    green = "#3EFFDC",
    violet = "#FF61EF",
    yellow = "#FFDA7B",
    black = "#000000",
  }
  lualine_nightfly.normal.a.bg = new_colors.blue
  lualine_nightfly.insert.a.bg = new_colors.green
  lualine_nightfly.visual.a.bg = new_colors.violet
  lualine_nightfly.command = {
    a = {
      gui = "bold",
      bg = new_colors.yellow,
      fg = new_colors.black,
    }
  }
  return lualine_nightfly
end

function _G._theme_changed(cs)
  if cs == "gruvbox" then
    require "fengwk.plugins.lualine".setup({ options = { theme = "gruvbox" } })
  elseif cs == "my-darkplus" or cs == "darkplus" or cs == "vscode" then
    require "fengwk.plugins.lualine".setup({ options = { theme = "onedark" } })
  elseif cs == "nightfly" then
    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
    require "fengwk.plugins.lualine".setup({ options = { theme = lualine_nightfly() } })
  else
    require "fengwk.plugins.lualine".setup({ options = { theme = "auto" } })
  end
end

vim.cmd[[
augroup user_theme
  autocmd!
  " autocmd ColorSchemePre * colorscheme default
  autocmd ColorScheme * lua _G._theme_changed(vim.fn.expand("<amatch>"))
augroup end
]]

vim.o.bg = "dark"
vim.cmd "colorscheme nightfly"
-- vim.cmd "colorscheme my-darkplus"
-- vim.cmd "colorscheme gruvbox"
-- vim.cmd "colorscheme kanagawa"
-- vim.cmd "colorscheme vscode"