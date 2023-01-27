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

-- 使用自动命令修复新插件缓冲区无法显示颜色的问题
vim.api.nvim_create_augroup("user_coclorizer", { clear = true })
vim.api.nvim_create_autocmd(
  { "BufNew" }, -- 或者FileType？
  { group = "user_coclorizer", pattern = "*", callback = function()
    colorizer.attach_to_buffer(0)
  end}
)