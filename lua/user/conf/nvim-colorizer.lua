-- https://github.com/norcalli/nvim-colorizer.lua

-- local colorizer = require "colorizer"
--
-- colorizer.setup(
--   {
--     "*",
--     "!json", -- 无法处理大json文件
--     css = { names = true },
--     html = { names = true },
--   },
--   {
--     RGB      = true, -- #RGB hex codes
--     RRGGBB   = true, -- #RRGGBB hex codes
--     names    = false, -- "Name" codes like Blue oe blue
--     RRGGBBAA = true, -- #RRGGBBAA hex codes
--     rgb_fn   = true, -- CSS rgb() and rgba() functions
--     hsl_fn   = true, -- CSS hsl() and hsla() functions
--     css      = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
--     css_fn   = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
--     -- Available modes: foreground, background, virtualtext
--     mode     = "background", -- Set the display mode.
--   })

-- https://github.com/NvChad/nvim-colorizer.lua
require("colorizer").setup {
  filetypes = {
    "*",
    css = { names = true },
    html = { names = true },
  },
  user_default_options = {
    names = false, -- "Name" codes like Blue or blue
  },
}

vim.cmd[[
augroup user_coclorizer
  autocmd!
  " autocmd ColorSchemePre * colorscheme default
  autocmd FileType * ColorizerAttachToBuffer
augroup end
]]