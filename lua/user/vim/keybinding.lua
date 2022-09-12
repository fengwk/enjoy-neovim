-- 保存
-- vim.keymap.set("n", "<C-s>", "<Cmd>w<CR>", { noremap = true, silent = true, desc = "Save Current Buffer" })
-- vim.keymap.set("n", "<C-S>", "<Cmd>wa<CR>", { noremap = true, silent = true, desc = "Save All Buffer" })

-- 快速移动光标
-- vim.keymap.set({ "n", "v" }, "<C-j>", "5j", { noremap = true, desc = "Quick Down" })
-- vim.keymap.set({ "n", "v" }, "<C-k>", "5k", { noremap = true, desc = "Quick Up" })
-- vim.keymap.set({ "n", "v" }, "<C-h>", "5h", { noremap = true, desc = "Quick Left" })
-- vim.keymap.set({ "n", "v" }, "<C-l>", "5l", { noremap = true, desc = "Quick Right" })

-- 清理高亮
vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { noremap = true, silent = true, desc = "Clear Highlight" })

-- 退出terminal模式
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit Terminal Mode" })

-- 调整window大小
vim.keymap.set("n", "<A-=>", "<Cmd>res +2<CR>", { noremap = true, silent = true, desc = "Increase Window Height" })
vim.keymap.set("n", "<A-->", "<Cmd>res -2<CR>", { noremap = true, silent = true, desc = "Decrease Window Height" })
vim.keymap.set("n", "<A-+>", "<Cmd>vertical res +2<CR>", { noremap = true, silent = true, desc = "Increase Window Height" })
vim.keymap.set("n", "<A-_>", "<Cmd>vertical res -2<CR>", { noremap = true, silent = true, desc = "Decrease Window Height" })