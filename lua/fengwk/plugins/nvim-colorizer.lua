-- https://github.com/NvChad/nvim-colorizer.lua

local ok, colorizer = pcall(require, "colorizer")
if not ok then
  return
end

colorizer.setup {
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