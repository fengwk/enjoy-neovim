-- https://github.com/christoomey/vim-system-copy
vim.cmd[[
let g:system_copy#copy_command='xclip -sel clipboard'
let g:system_copy#paste_command='xclip -sel clipboard -o'
let g:system_copy_silent = 1
]]