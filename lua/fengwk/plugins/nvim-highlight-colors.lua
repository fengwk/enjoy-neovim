-- https://github.com/NvChad/nvim-colorizer.lua
local ok, colorizer = pcall(require, "colorizer")
if not ok then
  return
end

colorizer.setup {
  filetypes = {
    css = { names = true },
    less = { names = true },
    sass = { names = true },
    scss = { names = true },
    html = { names = true },
    "*", -- 必须放在最后
  },
  user_default_options = {
    names = false,
  },
}
