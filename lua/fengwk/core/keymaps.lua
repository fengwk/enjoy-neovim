-- 使用空格作为leader键
vim.g.mapleader = " "

local keymap = vim.keymap

-- <C-z>将强制推出vim，删除这个快捷键放置误触
keymap.set("n", "<C-z>", "<nop>")

-- 保存
keymap.set("n", "<C-s>", "<Cmd>w<CR>", { silent = true, desc = "Save Current Buffer" })

-- 退出
keymap.set("n", "<C-q>", "<Cmd>q<CR>", { silent = true, desc = "Quit Current Buffer" })

-- 快速移动光标
-- keymap.set({ "n", "x" }, "<C-j>", "5j", { noremap = true, desc = "Quick Down" })
-- keymap.set({ "n", "x" }, "<C-k>", "5k", { noremap = true, desc = "Quick Up" })
-- keymap.set({ "n", "x" }, "<C-h>", "5h", { noremap = true, desc = "Quick Left" })
-- keymap.set({ "n", "x" }, "<C-l>", "5l", { noremap = true, desc = "Quick Right" })

-- 清理高亮
keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { silent = true, desc = "Clear Highlight" })

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
keymap.set("n", "[Q", "<Cmd>colder<CR>", { silent = true, desc = "Quickfix Prev" })
keymap.set("n", "]Q", "<Cmd>cnewer<CR>", { silent = true, desc = "Quickfix Next" })

-- 复制整个缓冲区内容
keymap.set("n", "<leader>y", "mpggVGy`p", { noremap = true, silent = true, desc = "Yank Entire Buffer" })
-- 放置visual mode下p覆盖"寄存器
keymap.set("x", "p", "pgvy", { noremap = true, desc = "Paste without override register" })

keymap.set({ "i", "s" }, "jk", "<Esc>", { noremap = true })
-- 在terimal模式下使用JK作为esc，避免和推出命令模式的esc按键冲突
keymap.set("t", "JK", "<Esc>", { noremap = true })

-- 在选中的每行执行宏
vim.cmd([[
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
]])

-- 如果当前行为空，使用A时将遵循上一行的缩进
keymap.set("n", "A", function ()
  local cur_line = vim.fn.line('.')
  local last_line = vim.fn.line('$')
  if cur_line > 1 and vim.fn.trim(vim.fn.getline('.')) == '' then
    vim.api.nvim_del_current_line()
    if cur_line == last_line then
      vim.api.nvim_feedkeys("o", 'n', true)
    else
      vim.api.nvim_feedkeys("O", 'n', true)
    end
  else
    vim.api.nvim_feedkeys("A", 'n', true)
  end
end, { desc = "Auto Indent" })

-- 展示当前缓冲区名称
vim.api.nvim_create_user_command("ShowBuffName", function() print(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())) end, {})
