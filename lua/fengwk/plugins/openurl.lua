local utils = require "fengwk.utils"
local jdtls_enhancer = require "fengwk.plugins.lsp.lsp-jdtls.jdtls-enhancer"

-- 定义url字符
local url_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~:/?#[]@!$&'()*+,;=%"
local url_chars_list = {}
local i = 1
while i <= #url_chars do
  table.insert(url_chars_list, url_chars:sub(i, i))
  i = i + 1
end

local function openurl(url)
  if url:match("^jdt") then
    jdtls_enhancer.jump_to_location(url)
  elseif url:match("^http[s]?") then
    utils.sys.system("xdg-open '" .. url .. "'", true)
  end
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
    if not vim.tbl_contains(url_chars_list, c) then
      break
    end
    start_col = start_col - 1
  end
  start_col = start_col + 1

  -- 从col位置开始向后找url结束点
  local end_col = col
  while end_col <= #line do
    local c = string.sub(line, end_col, end_col)
    if not vim.tbl_contains(url_chars_list, c) then
      break
    end
    end_col = end_col + 1
  end

  -- 截取url
  local url = string.sub(line, start_col, end_col - 1)
  return url
end

vim.keymap.set("n", "<leader>ou", function()
  local url = geturl()
  openurl(url)
end)
