local utils = require "fengwk.utils"

-- 全局变量定义
-- "single", "double" or "rounded"
vim.g.__border = "rounded"

-- 设置非文件类型
-- TODO 将所有的非用户文件类型都归为一类在某些情况下可能有问题，例如在自动关闭非用户文件时也会作用于gitcommit类型，因此需要特殊处理这些情况
utils.vim.setup_special_ft { "packer", "NvimTree", "toggleterm", "TelescopePrompt", "qf", "aerial", "dapui_scopes",
  "dapui_stacks", "dapui_breakpoints", "dapui_console", "dap-repl", "dapui_watches", "dap-repl", "gitcommit", "gitrebase", "diff", "cmp_menu" }
-- 设置大文件行数阈值，1W行
utils.vim.setup_large_flines(10000)
-- 设置大文件占用内存阈值，256K
utils.vim.setup_large_fsize(1024 * 128)

-- 历史命令记录条数
vim.g.history = 200

-- 为悬浮窗口提供透明度，[0..100]，0为不透明，在colorscheme中动态设置
-- vim.o.winblend = 20
vim.o.winblend = 0 -- TODO 暂未找到方法可以动态切换所有库的winblend，为了自由切换主题时不产生问题先禁用混合
-- 弹出窗口的透明度，例如补全窗口
vim.o.pumblend = vim.o.winblend

-- 设置终端名称为文件名
-- vim.o.title=true
-- 为终端设置指定标题
local function set_title(title)
  -- 将标题发送到终端
  -- '\27'为ASCII字符ESC表示控制序列开始
  -- ']'是OSC(Operating System Command)的开始
  -- '0;'表示窗口标题
  -- '\7'是ASCII字符BEL表示控制序列结束
  io.write("\27]0;" .. title .. "\7")

  -- 如果当前是tmux环境执行tmux命令设置tmux window名称
  local env_tmux = os.getenv("TMUX")
  if env_tmux and vim.trim(env_tmux) ~= "" then
    utils.sys.system("tmux rename-window '" .. title .. "'")
  end
end
-- 刷新终端标题
local function refresh_title(force)
  local title = ""
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  if utils.vim.is_sepcial_ft() then
    title = utils.vim.ft()
  else
    title = vim.fn.expand('%:t')
  end
  if force or string.len(title) > 0 then
    if string.len(title) > 0 then
      title = " - " .. title
    end
    title = "nvim ~ " .. cwd .. title
    -- 发送title到终端标题
    set_title(title)
  end
end
-- 注册标题自动刷新
vim.api.nvim_create_augroup("NvimTitleChange", { clear = true })
vim.api.nvim_create_autocmd(
  { "BufEnter" },
  {
    group = "NvimTitleChange",
    callback = function()
      vim.schedule(function()
        refresh_title(true)
      end)
    end
  }
)
-- 当离开nvim时重新设置标题为当前路径
vim.api.nvim_create_augroup("nvim_title", { clear = true })
vim.api.nvim_create_autocmd(
  { "VimLeave" },
  {
    group = "nvim_title",
    callback = function()
      vim.schedule(function()
        local pwd = os.getenv('PWD')
        local shell = os.getenv('SHELL')
        shell = string.match(shell, "[^/]+$")
        set_title(shell .. " ~ " .. string.match(pwd .. "", '.*/(.*)'))
      end)
    end
  }
)

-- 搜索配置
vim.o.hlsearch = true   -- 搜索高亮
vim.o.incsearch = true  -- 搜索时定位到目标位置
vim.o.ignorecase = true -- 忽略大小写敏感匹配
vim.o.smartcase = true  -- 如果同时输入大小写则进行大小写敏感匹配

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

-- 自动换行
vim.o.wrap = true

-- 制表符与缩进
vim.o.tabstop = 4        -- 指定vim中显示的制表符宽度
vim.o.softtabstop = 4    -- 指定tab键宽度
vim.o.shiftwidth = 4     -- 设置 >> << == 时的缩进宽度
vim.o.expandtab = true   -- 使用空格进行缩进
vim.o.autoindent = true  -- 在这种缩进形式中，新增加的行和前一行使用相同的缩进形式
vim.o.smartindent = true -- 在这种缩进模式中，每一行都和前一行有相同的缩进量，同时这种缩进模式能正确地识别出花括号，当前一行为开花括号“{”时，下一新行将自动增加缩进；当前一行为闭花括号“}”时，则下一新行将取消缩进

-- 使用treesitter进行折叠
-- zc 折叠当前代码闭合片段，再次zc折叠上一层级的代码闭合片段
-- zm 折叠与当前已折叠同层级的代码片段
-- zo zc的反向操作
-- zr zm的反向操作
-- zR 打开所有折叠
-- 使用[z和]z可以跳到折叠区间的前后
vim.o.foldmethod = "indent"
vim.o.foldlevel = 999

-- 设置特殊符号显示
-- :set list      显示非可见字符
-- :set nolist    隐藏非可见字符
-- :set listchars 设置非可见字符的显示模式
vim.o.list = true
-- tab      制表符
-- trail    行末空格
-- precedes 左则超出屏幕范围部分
-- extends  右侧超出屏幕范围部分
vim.o.listchars = "tab:>-,trail:·,precedes:«,extends:»,"

-- 使用系统剪切板作为无名寄存器
-- vim.o.clipboard = 'unnamed'
-- https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
-- vim.cmd("set clipboard^=unnamed,unnamedplus")
vim.cmd("set clipboard=unnamedplus")

-- 持久化undo日志，使得退出重进也能进行undo操作
vim.o.undofile = true

-- 本机拼写检查
-- vim.cmd [[
-- set spell
-- set spelllang=en_us
-- ]]

-- 编码格式
vim.o.encoding = "utf-8"     -- vim内部字符表示编码
vim.o.fileencoding = "utf-8" -- 文件编码

-- 窗口拆分
-- vim.o.splitright = true -- 拆分后定位到右边
-- vim.o.splitbelow = true -- 拆分后定位到下方

-- 将"-"作为word的一部分
-- vim.opt.iskeyword:append("-")

-- 更快的代码高亮
-- vim.o.updatetime = 1000

-- 非tty环境下更改诊断提示样式
if not utils.sys.is_tty() then
  vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
end

-- 判断是否是用户窗口
local function is_user_buf(bufnr)
  local buf_name = vim.fn.bufname(bufnr)
  if buf_name:match("^%[dap%-terminal%]") then
    return false
  end
  if vim.api.nvim_buf_is_valid(bufnr) and utils.vim.is_sepcial_ft(bufnr) then
    return false
  end
  return true
end

-- 自动在关闭窗口，实现退出时不同另外关闭terminal等窗口
vim.api.nvim_create_augroup("auto_close_win", { clear = true })
vim.api.nvim_create_autocmd({ "WinClosed" }, {
  group = "auto_close_win",
  pattern = "*",
  callback = function()
    local cur_win = tonumber(vim.fn.expand("<amatch>"))
    local cur_buf = vim.api.nvim_win_get_buf(cur_win)
    -- 如果当前关闭的是特殊窗口不进行处理
    -- 这个条件可以规避类似cmp_menu窗口自动关闭时引发的问题
    if utils.vim.is_sepcial_ft(cur_buf) then
      return
    end
    -- 计算当前用户窗口数量和非用户窗口数量
    local user_win_cnt = 0
    local other_win_cnt = 0
    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
      local bufnr = vim.api.nvim_win_get_buf(win)
      if bufnr and win ~= cur_win then -- 忽略当前要关闭的窗口
        if is_user_buf(bufnr) then
          user_win_cnt = user_win_cnt + 1
        else
          other_win_cnt = other_win_cnt + 1
        end
      end
    end
    -- 除去当前关闭的窗口后没有用户窗口，且还存在非用户窗口则尝试进行关闭
    if user_win_cnt == 0 and other_win_cnt > 0 then
      vim.schedule(function()
        -- vim.cmd("qall")
        local ok = pcall(vim.cmd, "qall")
        if not ok then
          vim.notify("No write since last change", vim.log.levels.ERROR)
        end
      end)
    end
  end
})
