-- 使用空格作为leader键
vim.g.mapleader = " "

local keymap = vim.keymap

-- 拖拽行，已在st上完成键位映射
keymap.set("n", "<C-S-J>", function()
  if vim.fn.getpos(".")[2] ~= vim.fn.getpos("$")[2] then
    vim.api.nvim_feedkeys(":move +1\n==", "n", true)
  end
end, { silent = true })
keymap.set("n", "<C-S-K>", function()
  if vim.fn.getpos(".")[2] ~= 1 then
    vim.api.nvim_feedkeys(":move -2\n==", "n", true)
  end
end, { silent = true })
keymap.set("x", "<C-S-J>", function()
  if vim.fn.getpos("'>")[2] ~= vim.fn.getpos("$")[2] then
    vim.api.nvim_feedkeys(":move '>+1\ngv=gv", "n", true)
  end
end, { silent = true })
keymap.set("x", "<C-S-K>", function()
  if vim.fn.getpos("'<")[2] ~= 1 then
    vim.api.nvim_feedkeys(":move '<-2\ngv=gv", "n", true)
  end
end, { silent = true })

-- <C-z>将强制推出vim，删除这个快捷键放置误触
keymap.set("n", "<C-z>", "<nop>")

-- 保存
keymap.set("n", "<C-s>", "<Cmd>w<CR>", { silent = true, desc = "Save Current Buffer" })

-- 退出
keymap.set("n", "<C-q>", "<Cmd>q<CR>", { silent = true, desc = "Quit Current Buffer" })

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

-- 黏贴后自动格式化黏贴区域
keymap.set("n", "p", function()
  vim.api.nvim_feedkeys("\"" .. vim.v.register .. "p", "n", true)
  local current_win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(current_win)
  local line = cursor[1]
  local col = cursor[2]
  vim.api.nvim_feedkeys("`[v`]=", "n", true) -- 这个命令可以选中最近插入的文本然后进行格式化
  vim.api.nvim_win_set_cursor(current_win, {line, col})
end)
keymap.set("x", "p", function()
  vim.api.nvim_feedkeys("\"" .. vim.v.register .. "p", "n", true)
  local current_win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(current_win)
  local line = cursor[1]
  local col = cursor[2]
  vim.api.nvim_feedkeys("gv=", "n", true)
  vim.api.nvim_win_set_cursor(current_win, {line, col})
end)

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

-- 打开新的临时缓冲区diff当前缓冲区变更
vim.cmd [[
  function! s:DiffCurrentBuffer()
    let filetype=&ft
    diffthis
    vnew
    r #
    exe "set filetype=" . filetype
    diffthis
    normal! ggdd
    exe "file [original]" . expand("#:t")
    exe "setlocal bt=nofile bh=wipe nobl noswf nomodifiable"
    set wrap
  endfunction
  com! DiffCurrentBuffer call s:DiffCurrentBuffer()
]]

-- 打开新的临时缓冲区用于diff
vim.cmd [[
  function! s:DiffVsplitBuffer()
    let filetype=&ft
    diffthis
    vnew
    exe "set filetype=" . filetype
    diffthis
    exe "file [diff buffer]"
    exe "setlocal bt=nofile bh=wipe nobl noswf"
    set wrap
    " 清理缓冲区问题
    call feedkeys('a1', 'n')
    call feedkeys("\<Esc>", 'n')
    call feedkeys('a', 'n')
    call feedkeys("\<BS>", 'n')
    call feedkeys("\<Esc>", 'n')
  endfunction
  com! DiffVsplitBuffer call s:DiffVsplitBuffer()
]]

-- 打开临时缓冲区
vim.cmd [[
  function! s:TempNew()
    let filetype=&ft
    new
    exe "set filetype=" . filetype
    diffthis
    exe "file [temp]"
    exe "setlocal bt=nofile bh=wipe nobl noswf"
    set wrap
  endfunction
  com! TempNew call s:TempNew()
]]

-- 打开垂直的临时缓冲区
vim.cmd [[
  function! s:TempVnew()
    let filetype=&ft
    vnew
    exe "set filetype=" . filetype
    diffthis
    exe "file [temp]"
    exe "setlocal bt=nofile bh=wipe nobl noswf"
    set wrap
  endfunction
  com! TempVnew call s:TempVnew()
]]

-- 打开临时缓冲区覆盖当前缓冲区
vim.cmd [[
  function! s:TempEnew()
    let filetype=&ft
    enew
    exe "set filetype=" . filetype
    diffthis
    exe "file [temp]"
    exe "setlocal bt=nofile bh=wipe nobl noswf"
    set wrap
  endfunction
  com! TempEnew call s:TempEnew()
]]
