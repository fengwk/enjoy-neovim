local themes = {
  ["doom-one"] = {
    config = "user.themes.doom-one",
    colorscheme = "doom-one",
  },
  ["github-nvim-theme"] = {
    config = "user.themes.github-nvim-theme",
  },
  ["catppuccin"] = {
    config = "user.themes.catppuccin",
  },
  ["themer"] = {
    config = "user.themes.themer",
  },
  ["darkplus"] = {
    colorscheme = "darkplus",
  },
}

local theme = themes["darkplus"]
if theme.config ~= nil then
  require(theme.config)
end
if theme.colorscheme ~= nil then
  vim.cmd("colorscheme " .. theme.colorscheme)
end