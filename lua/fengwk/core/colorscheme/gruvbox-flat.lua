local config = require("gruvbox.config")
local colors = require("gruvbox.colors").setup(config)

local gruvbox = {}

gruvbox.normal = {
  a = { bg = colors.blue, fg = colors.black, gui = "bold" },
  b = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
  c = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
}

gruvbox.insert = {
  a = { bg = colors.green, fg = colors.black, gui = "bold" },
  b = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
}

gruvbox.command = {
  a = { bg = colors.purple, fg = colors.black, gui = "bold" },
  b = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
}

gruvbox.visual = {
  a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
  b = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
}

gruvbox.replace = {
  a = { bg = colors.red, fg = colors.black, gui = "bold" },
  b = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
}

gruvbox.inactive = {
  a = { bg = colors.bg_statusline, fg = colors.fg_gutter },
  b = { bg = colors.bg_statusline, fg = colors.fg_gutter },
  c = { bg = colors.bg_statusline, fg = colors.fg_gutter },
}

vim.g.gruvbox_flat_style = "hard"
vim.g.gruvbox_italic_comments = false
-- vim.g.gruvbox_transparent = true
vim.g.gruvbox_transparent = false

return {
  setup = function()
    require("fengwk.plugins.lualine").setup({
      options = {
        theme = gruvbox
      }
    })
  end
}
