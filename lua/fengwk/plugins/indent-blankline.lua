-- https://github.com/lukas-reineke/indent-blankline.nvim

local ok, ibl = pcall(require, "ibl")
if not ok then
  vim.notify("indent_blankline can not be required.")
  return
end

ibl.setup({
  -- 需要treesiter支持，开启将调用treesitter影响大文件的启动
  -- show_current_context = true, -- 如果为true突出当前区域缩进线
  -- show_current_context_start = false, -- 如果为true突出当前区域开始位置
})
