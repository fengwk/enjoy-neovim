-- leader键
vim.g.mapleader = ' '
-- vim.g.mapleader = '\\'

-- 历史命令记录条数
vim.g.history = 200

-- 搜索高亮，默认true
vim.o.hlsearch = true
-- 搜索时定位到目标位置，默认true
vim.o.incsearch = true
-- 只有输入大写字符时才进行大小写敏感匹配
vim.o.ignorecase = true
vim.o.smartcase = true

-- 背景色：dark、light
-- vim.o.bg = 'dark'
-- vim.o.bg = 'light'

-- 允许鼠标控制光标，nv代表normal和visual
-- vim.o.mouse = 'nv'

-- 显示行号
vim.o.number = true
-- 显示相对行号
vim.o.relativenumber = true

-- 滚动时保持上下边距
vim.o.scrolloff = 5
-- 该设置可以将光标定位到窗口中间位置
-- vim.o.scrolloff = 999

-- 使用utd-8编码
vim.o.encoding = 'utf-8'

-- 真彩色支持
vim.o.termguicolors = true
-- 背景透明
-- vim.cmd([[
--   let &t_ut=''
--   highlight Normal guibg=NONE ctermbg=None
-- ]])

-- 指定vim中显示的制表符宽度
vim.o.tabstop = 4
-- 指定tab键宽度
vim.o.softtabstop = 4
-- 设置 >> << == 时的缩进宽度
vim.o.shiftwidth = 4
-- 使用空格进行缩进
vim.o.expandtab = true
-- 辅助缩进
vim.o.autoindent = true
vim.o.smartindent = true

-- 设置特殊符号显示
-- :set list      显示非可见字符
-- :set nolist    隐藏非可见字符
-- :set listchars 设置非可见字符的显示模式
vim.o.list = true
-- tab      制表符
-- trail    行末空格
-- precedes 左则超出屏幕范围部分
-- extends  右侧超出屏幕范围部分
vim.o.listchars= 'tab:>-,trail:·,precedes:«,extends:»,'

-- 使用系统剪切板作为无名寄存器
-- vim.o.clipboard = 'unnamed'

-- 持久化undo日志，使得退出重进也能进行undo操作
vim.o.undofile = true

-- 行高亮
vim.o.cursorline = true

-- 文件编码
vim.o.fileencoding = "utf-8"

-- 使用treesitter进行折叠
-- zc 折叠当前代码闭合片段，再次zc折叠上一层级的代码闭合片段
-- zm 折叠与当前已折叠同层级的代码片段
-- zo zc的反向操作
-- zr zm的反向操作
-- zR 打开所有折叠
vim.o.foldmethod = "indent"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = false
vim.o.foldlevel = 99

-- 更快的代码高亮
-- vim.o.updatetime = 1000

-- 重新打开时光标定位到退出时的位置
vim.cmd([[
  if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"zz" | endif
  endif
]])

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