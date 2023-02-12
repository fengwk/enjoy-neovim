-- 使用空格作为leader键
vim.g.mapleader = " "

local keymap = vim.keymap

-- <C-z>将强制推出vim，删除这个快捷键放置误触
keymap.set("n", "<C-z>", "<nop>")

-- 保存
-- keymap.set("n", "<C-s>", "<Cmd>w<CR>", { silent = true, desc = "Save Current Buffer" })
-- keymap.set("n", "<C-S>", "<Cmd>wa<CR>", { silent = true, desc = "Save All Buffer" })

-- 退出
-- keymap.set("n", "<C-q>", "<Cmd>q<CR>", { silent = true, desc = "Quit Current Buffer" })
-- keymap.set("n", "<C-Q>", "<Cmd>qa<CR>", { silent = true, desc = "Quit All Buffer" })

-- 快速移动光标
-- keymap.set({ "n", "x" }, "<C-j>", "5j", { noremap = true, desc = "Quick Down" })
-- keymap.set({ "n", "x" }, "<C-k>", "5k", { noremap = true, desc = "Quick Up" })
-- keymap.set({ "n", "x" }, "<C-h>", "5h", { noremap = true, desc = "Quick Left" })
-- keymap.set({ "n", "x" }, "<C-l>", "5l", { noremap = true, desc = "Quick Right" })

-- 清理高亮
keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { silent = true, desc = "Clear Highlight" })

-- 使用very magic模式进行匹配，更接近于Perl
-- keymap.set("n", "/", "/\\v", { noremap = true, desc = "Search Perl" })

-- 退出terminal模式
keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "Exit Terminal Mode" })

-- 调整window大小
keymap.set("n", "<A-=>", "<Cmd>res +2<CR>", { silent = true, desc = "Increase Window Height" })
keymap.set("n", "<A-->", "<Cmd>res -2<CR>", { silent = true, desc = "Decrease Window Height" })
keymap.set("n", "<A-+>", "<Cmd>vertical res +2<CR>", { silent = true, desc = "Increase Window Height" })
keymap.set("n", "<A-_>", "<Cmd>vertical res -2<CR>", { silent = true, desc = "Decrease Window Height" })

-- quickfix
keymap.set("n", "[q", "<Cmd>cp<CR>", { silent = true, desc = "Quickfix Prev" })
keymap.set("n", "]q", "<Cmd>cn<CR>", { silent = true, desc = "Quickfix Next" })

-- 复制整个缓冲区内容
keymap.set("n", "<leader>y", "mpggVGy`p", { noremap = true, silent = true, desc = "Yank Entire Buffer" })
-- 放置visual mode下p覆盖"寄存器
keymap.set("x", "p", "pgvy", { noremap = true, desc = "Paste without override register" })
-- 使用系统剪切板复制
-- keymap.set({ "n", "x" }, "<leader>y", "\"+y", { noremap = true, silent = true, desc = "Yank Entire Buffer" })
-- keymap.set({ "n" }, "<leader>Y", "\"+Y", { noremap = true, silent = true, desc = "Yank Entire Buffer" })
-- 使用系统剪切板黏贴
-- keymap.set({ "n", "x" }, "<leader>p", "\"+p", { noremap = true, silent = true, desc = "Yank Entire Buffer" })
-- keymap.set("n" , "<leader>P", "\"+P", { noremap = true, silent = true, desc = "Yank Entire Buffer" })

-- 删除单个字符不复制到寄存器中
-- keymap.set("n", "x", "\"_x", { noremap = true })

-- 这个脚本允许在选中的每行执行宏
vim.cmd([[
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
]])