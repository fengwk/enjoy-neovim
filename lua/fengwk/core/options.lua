local utils = require("fengwk.utils")
-- 设置非文件类型
utils.set_not_file_ft({ "packer", "NvimTree", "toggleterm", "TelescopePrompt", "qf", "aerial", "dapui_scopes", "dapui_stacks", "dapui_breakpoints", "dapui_console", "dap-repl", "dapui_watches", "dap-repl", "gitcommit", "diff" })
-- 设置大文件行数阈值，3W行
utils.set_large_file_lines_threshold(30000)
-- 设置大文件占用内存阈值，512K
utils.set_large_file_size_threshold(1024 * 512)

-- 历史命令记录条数
vim.g.history = 200

-- 搜索配置
vim.o.hlsearch = true -- 搜索高亮
vim.o.incsearch = true -- 搜索时定位到目标位置
vim.o.ignorecase = true -- 忽略大小写敏感匹配
vim.o.smartcase = true -- 如果同时输入大小写则进行大小写敏感匹配

-- 背景色：dark、light
vim.o.bg = "dark"
-- 真彩色支持
vim.o.termguicolors = true
-- 背景透明
-- vim.cmd([[
--   let &t_ut=''
--   highlight Normal guibg=NONE ctermbg=None
-- ]])

-- 行高亮
vim.o.cursorline = true

-- 允许鼠标控制光标，nv代表normal和visual
vim.o.mouse = "nv"
-- vim.o.mouse = ""

-- 行号与相对行号显示
vim.o.number = true
vim.o.relativenumber = true

-- 滚动时保持上下边距
vim.o.scrolloff = 5
-- 该设置可以将光标定位到窗口中间位置
-- vim.o.scrolloff = 999

-- 关闭自动换行显示
-- vim.o.wrap = false

-- 制表符与缩进
vim.o.tabstop = 4 -- 指定vim中显示的制表符宽度
vim.o.softtabstop = 4 -- 指定tab键宽度
vim.o.shiftwidth = 4 -- 设置 >> << == 时的缩进宽度
vim.o.expandtab = true -- 使用空格进行缩进
vim.o.autoindent = true -- 在这种缩进形式中，新增加的行和前一行使用相同的缩进形式
vim.o.smartindent = true -- 在这种缩进模式中，每一行都和前一行有相同的缩进量，同时这种缩进模式能正确地识别出花括号，当前一行为开花括号“{”时，下一新行将自动增加缩进；当前一行为闭花括号“}”时，则下一新行将取消缩进

-- 使用treesitter进行折叠
-- zc 折叠当前代码闭合片段，再次zc折叠上一层级的代码闭合片段
-- zm 折叠与当前已折叠同层级的代码片段
-- zo zc的反向操作
-- zr zm的反向操作
-- zR 打开所有折叠
-- 使用[z和]z可以跳到折叠区间的前后
vim.o.foldmethod = "indent"
-- 使用treesitter能力进行折叠
-- 如果无法折叠可以使用zx更新折叠解决
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1337
-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = false
vim.o.foldlevel = 99

-- 设置特殊符号显示
-- :set list      显示非可见字符
-- :set nolist    隐藏非可见字符
-- :set listchars 设置非可见字符的显示模式
vim.o.list = true
-- tab      制表符
-- trail    行末空格
-- precedes 左则超出屏幕范围部分
-- extends  右侧超出屏幕范围部分
vim.o.listchars= "tab:>-,trail:·,precedes:«,extends:»,"

-- 使用系统剪切板作为无名寄存器
-- vim.o.clipboard = 'unnamed'
-- https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
vim.cmd("set clipboard^=unnamed,unnamedplus")

-- 持久化undo日志，使得退出重进也能进行undo操作
vim.o.undofile = true

-- 编码格式
vim.o.encoding = "utf-8" -- vim内部字符表示编码
vim.o.fileencoding = "utf-8" -- 文件编码

-- 窗口拆分
-- vim.o.splitright = true -- 拆分后定位到右边
-- vim.o.splitbelow = true -- 拆分后定位到下方

-- 将"-"作为word的一部分
-- vim.opt.iskeyword:append("-")

-- 更快的代码高亮
-- vim.o.updatetime = 1000

-- 重新打开时光标定位到退出时的位置
vim.cmd([[
  if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"zz" | endif
  endif
]])

-- 非tty环境下更改诊断提示样式
if not utils.is_tty() then
  vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
end