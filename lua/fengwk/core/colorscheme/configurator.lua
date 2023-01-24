local function setup()
  vim.o.bg = "dark"
  vim.g.everforest_transparent_background = 1 -- everforest透明背景

  -- vim.cmd("colorscheme nightfly")
  -- vim.cmd("colorscheme my-darkplus")
  -- vim.cmd("colorscheme gruvbox")
  -- vim.cmd("colorscheme kanagawa")
  -- vim.cmd("colorscheme vscode")
  vim.cmd("colorscheme everforest")
end

local function on_change(colorscheme)
  if colorscheme == "gruvbox" then
    require("fengwk.plugins.lualine").setup({ options = { theme = "gruvbox" } })
  elseif colorscheme == "my-darkplus" or colorscheme == "darkplus" or colorscheme == "vscode" then
    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#569BD5 ]])
    require "fengwk.plugins.lualine".setup({ options = { theme = "onedark" } })
  elseif colorscheme == "everforest" then
    require("fengwk.plugins.lualine").setup({ options = { theme = "everforest" } })
  elseif colorscheme == "nightfly" then
    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
    require("fengwk.core.colorscheme.lualine-nightfly").setup()
  elseif colorscheme == "kanagawa" then
    require("fengwk.core.colorscheme.lualine-kanagawa").setup()
  else
    require("fengwk.plugins.lualine").setup({ options = { theme = "auto" } })
  end
end

return {
  setup = setup,
  on_change = on_change,
}