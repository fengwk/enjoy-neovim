local utils = require "fengwk.utils"
local jdtls_enhancer = require "fengwk.plugins.lsp.lsp-jdtls.jdtls-enhancer"

-- 定义url字符
local url_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~:/?#[]@!$&'()*+,;=%"
local ps_list = { "()", "[]", "{}", "<>", "\"\"", "''", "``" }

local function openurl(url)
  if url:match("^jdt") then
    jdtls_enhancer.jump_to_location(url)
  elseif url:match("^https?://[^%s]+$") then
    utils.sys.open(url)
  end
end

local function do_trim_pair(str, ps)
  if str and str:sub(1, 1) == ps[1] and str:sub(#str, #str) == ps[2] then
    str = str:sub(2, #str - 1)
    return do_trim_pair(str, ps)
  end
  return str
end

local function trim_pair(str)
  for _, ps in ipairs(ps_list) do
    str = do_trim_pair(str, ps)
  end
  return str
end

local function geturl()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- 第一个位置是0，由于lua索引的原因，col需要+1
  col = col + 1

  -- 从col位置开始向前找url起始点
  local start_col = col
  while start_col > 0 do
    local c = string.sub(line, start_col, start_col)
    if utils.lang.str_index(url_chars, c) == 0 then
      break
    end
    start_col = start_col - 1
  end
  start_col = start_col + 1

  -- 从col位置开始向后找url结束点
  local end_col = col
  while end_col <= #line do
    local c = string.sub(line, end_col, end_col)
    if utils.lang.str_index(url_chars, c) == 0 then
      break
    end
    end_col = end_col + 1
  end

  -- 截取url
  local url = string.sub(line, start_col, end_col - 1)
  url = url:match("https?://[^%s]+")
  return trim_pair(url)
end

vim.keymap.set("n", "<leader>ou", function()
  local url = geturl()
  openurl(url)
end)

-- TODO 鼠标点击打开url
