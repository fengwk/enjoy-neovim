-- 兼容lualine
vim.cmd([[
  augroup user_vim_visual_multi
    autocmd!
    autocmd User visual_multi_start lua require("lualine").hide()
    autocmd User visual_multi_exit  lua require("lualine").hide({ unhide = true })
  augroup end
]])

-- VM cursor 模式，类比 vim normal 模式
-- VM extend 模式，类比 vim visual 模式，在这个模式下可以使用n、N继续进行选中
-- 在这两个 VM 模式下，上下左右键均可自由移动光标
-- <Tab> 键可以在这两个 VM 模式间切换

-- <C-up> 在 vim normal 模式下使用，如果不在 VM cursor 模式则进入，为当前位置和上边位置创建两个 VM 模式下的光标
-- <C-down> 是 <C-up> 的反向操作

-- q 在 VM extend 模式下跳过当前光标所在的选中，并跳到下一个可选中位置选中
-- Q 在 VM extend 模式下跳过当前光标所在的选中，并跳回上一个已选中的位置
-- <C-n> 在 vim normal 模式下使用当前单词并进入 VM extend 模式
-- <C-n> 在 vim visual 模式下使用选中内容进入 VM extend 模式
-- \\/ 进入 VM 搜索模式，使用搜索到的内容进入 VM extend 模式
-- \\\ 使当前光标所在位置进入 VM 模式
-- \\A 全选当前前下标单单词，或已选中单词进入 VM 模式
-- \\a 对齐
-- \\t 多个 VM extend 选中区域交换
-- \\gS 重新选择之前最后一个 VM 模式选中

-- :h VM_maps
-- https://github.com/mg979/vim-visual-multi/blob/master/autoload/vm/maps/all.vim
vim.g.VM_maps = {
  ["Select h"] = "<C-Left>", -- 选中左边进入 VM extend 模式
  ["Select l"] = "<C-Right>", -- 选中左边进入 VM extend 模式
}