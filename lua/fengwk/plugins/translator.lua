-- 依赖于translate-shell
-- yay -S translate-shell

-- google翻译太慢，使用deepl
-- yay -S python-deepl

-- normal <leader>t{motion} 翻译{motion}区间
-- normal <leader>tt{motion} 翻译整行
-- normal <leader>t{motion} 翻译当前光标到行末
-- visual <leader>t{motion} 翻译选择区间
-- Translate命令 翻译输入单词

local utils = require("fengwk.utils")
local keymap = vim.keymap
local api = vim.api
local trans_engine = 'google'
local use_cmd = "deepl"

local cmds = {
  trans = function(text, is_chinese)
    local cmd = { "trans", "-brief", "-no-warn" }
    if trans_engine then
      table.insert(cmd, "-e")
      table.insert(cmd, trans_engine)
    end
    table.insert(cmd, is_chinese and "zh:en" or "en:zh")
    table.insert(cmd, text)
    return cmd
  end,

  deepl = function(text, is_chinese)
    local cmd = { "deepl", "text", "--to", is_chinese and "en-us" or "zh", text }
    return cmd
  end
}

local function open_float_win(lines)
  if vim.tbl_isempty(lines) then
    return
  end

  -- 创建buf
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  api.nvim_buf_set_option(buf, 'modifiable', false)
  keymap.set("n", "q", "<Cmd>q!<CR>", { silent = true, buffer = buf })
  keymap.set("n", "<Esc>", "<Cmd>q!<CR>", { silent = true, buffer = buf })
  keymap.set("n", "<C-q>", "<Cmd>q!<CR>", { silent = true, buffer = buf })
  keymap.set("n", "<C-c>", "<Cmd>q!<CR>", { silent = true, buffer = buf })

  -- 窗口大小
  local cur_win = api.nvim_get_current_win()
  local max_h = math.ceil(api.nvim_win_get_height(cur_win) / 2)
  local max_w = math.ceil(api.nvim_win_get_width(cur_win) / 2)
  local fwin_w = 0
  local len = 0
  local ncount = 0
  for _, v in ipairs(lines) do
    local l = string.len(v)
    if v == "" then
      ncount = ncount + 1
    end
    fwin_w = math.max(l, fwin_w)
    len = len + l
  end
  fwin_w = math.min(fwin_w, max_w)
  fwin_w = math.max(fwin_w, 5)
  local fwin_h = math.ceil(len / fwin_w) + ncount
  fwin_h = math.min(fwin_h, max_h)
  fwin_h = math.max(fwin_h, 1)

  -- 定义窗口的配置
  local win_opts = {
    relative = "cursor",
    row = 1,
    col = 1,
    width = fwin_w,
    height = fwin_h,
    style = "minimal",
    border = vim.g.__border,
    noautocmd = true,
  }

  local float_win = api.nvim_open_win(buf, false, win_opts)
  api.nvim_win_set_option(float_win, 'wrap', true)
  api.nvim_set_current_win(float_win)
end

-- 检查str是否为中文
local function isChinese(str)
  local totalCount = 0
  local chineseCount = 0
  local chars = utils.utf8.parse(str)
  for _, c in ipairs(chars) do
    if c.s and string.match(c.s, "[%z\1-\127\194-\244][\128-\191]") then
      chineseCount = chineseCount + 1
    end
  end
  return (chineseCount / totalCount) > 0.6
end

local function translate(textobject, op)
  local text = table.concat(textobject, "\n")
  local cmd = cmds[use_cmd](text, isChinese(text))
  local merged = {}
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, res)
      if res then
        vim.list_extend(merged, res)
      end
    end,
    on_exit = function()
      local res_text = vim.trim(table.concat(merged, "\n"))
      if string.len(res_text) > 0 then
        if op == "fwin" then
          open_float_win(vim.split(res_text, "\n"))
        elseif op == "print" then
          print(res_text)
        elseif op == "printcopy" then
          vim.fn.setreg('+', res_text)
          vim.fn.setreg('"', res_text)
          print(res_text)
        elseif op == "write" then
          vim.fn.setreg('+', res_text)
          vim.fn.setreg('"', res_text)
          vim.api.nvim_feedkeys('p', 'n', true)
        end
      else
        vim.notify("empty translate result", vim.log.levels.WARN)
      end
    end
  })
end

keymap.set("n", "<leader>t", function()
  utils.motion.operator(function(args)
    translate(args.textobject, "fwin")
  end)
end)
keymap.set("n", "<leader>tt", function()
  utils.motion.line(function(args)
    translate(args.textobject, "fwin")
  end)
end)
keymap.set("n", "<leader>T", function()
  utils.motion.eol(function(args)
    translate(args.textobject, "fwin")
  end)
end)
keymap.set("v", "<leader>t", function()
  utils.motion.visual(function(args)
    translate(args.textobject, "fwin")
  end)
end)
api.nvim_create_user_command("Translate", function(args)
    if args and args.fargs and #args.fargs > 0 then
      local input = args.fargs[1]
      translate(vim.split(input, "\n"), "print")
    end
end, { nargs = 1 })
api.nvim_create_user_command("TranslateC", function(args)
    if args and args.fargs and #args.fargs > 0 then
      local input = args.fargs[1]
      translate(vim.split(input, "\n"), "printcopy")
    end
end, { nargs = 1 })
api.nvim_create_user_command("TranslateW", function(args)
    if args and args.fargs and #args.fargs > 0 then
      local input = args.fargs[1]
      translate(vim.split(input, "\n"), "write")
    end
end, { nargs = 1 })
