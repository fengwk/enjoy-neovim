-- 兼容lualine
vim.cmd([[
  augroup user_vim_visual_multi
    autocmd!
    autocmd User visual_multi_start lua require("lualine").hide()
    autocmd User visual_multi_exit  lua require("lualine").hide({ unhide = true })
  augroup end
]])