local lang = require "fengwk.utils.lang"
local fs = require "fengwk.utils.fs"
local utf8 = require "fengwk.utils.utf8"

-- 给定一个col，这个方法将返回col所在字符的的结束col，注意col从0开始
-- col vim.api.nvim_buf_get_mark(bufnr, ">") 直接获取到的col，当前字符的开始
local function utf8_char_end_col(s, col)
  local cs = utf8.parse(s)
  local idx = 1 -- cs的索引
  local pos = 0 -- 下次要检查的字符开始
  while pos <= col and idx <= #cs do
    pos = pos + cs[idx].n
    idx = idx + 1
  end
  return pos - 1
end

local v = {}

v.ft = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_option(bufnr, "filetype")
end

v.setup_special_ft = function(sfts)
  v.sepcial_ft = sfts
end

v.is_sepcial_ft = function(bufnr)
  return vim.tbl_contains(v.sepcial_ft or {}, v.ft(bufnr))
end

v.setup_large_flines = function(flines)
  v.large_flines = flines
end

v.setup_large_fsize = function(fsize)
  v.large_fsize = fsize
end

v.is_large_buf = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  -- 检查文件大小是否超过阈值
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > v.large_fsize then
    return true
  end
  -- 检查文件行数是否超过阈值
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count and line_count > v.large_flines then
    return true
  end
  return false
end

-- 支持utf8的获取选中的内容
v.selection_lines = function(bufnr)
  bufnr = bufnr or 0
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(bufnr, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(bufnr, ">"))
  -- 获取所有行内容
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row - 1, end_row, false)
  -- 获取指定缓冲区编码
  local encoding = vim.api.nvim_buf_get_option(bufnr, 'fileencoding')
  -- 转为lua索引
  local start_col_idx = start_col + 1
  local end_col_idx = end_col + 1
  if encoding == "utf-8" then
    -- 如果是utf-8编码则修正end_col位置
    end_col_idx = utf8_char_end_col(lines[#lines], end_col) + 1
  end
  -- 截取内容
  if start_row == end_row then
    lines[1] = lines[1]:sub(start_col_idx, end_col_idx)
  else
    lines[1] = lines[1]:sub(start_col_idx)
    lines[#lines] = lines[#lines]:sub(1, end_col_idx)
  end
  return lines, start_row, start_col, end_row, end_col
end

v.cd = function(root, filename)
  -- 不能使用and vim.fn.getcwd() ~= root条件，有时候切换会有延迟这个判断会失效
  if not lang.str_empty(root) and fs.is_dir(root) then
    root = vim.fn.expand(root)
    vim.cmd("cd " .. root)
    local t_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
    if t_ok then
      nvim_tree_api.tree.change_root(root) -- 主动修改nvim-tree root，否则切换会出现问题
    end
  end
  if not lang.str_empty(filename) and fs.exists(filename) then
    filename = vim.fn.expand(filename)
    -- 自动切换到nvim-tree聚焦到打开的文件
    local ok_finders_find_file, finders_find_file = pcall(require, "nvim-tree.actions.finders.find-file")
    if ok_finders_find_file then
      finders_find_file.fn(filename)
    end
  end
end

vim.cmd [[
function! GetSelectedText()
  if visualmode() ==# 'v'
    return @"  " . getline("'<", "'>")
  elseif visualmode() ==# 'V'
    return @" . "\n" . getline("'<", "'>")
  elseif visualmode() ==# "\<C-v>"
    let selected_lines = getline("'<", "'>")
    let selected_text = ''
    for line in selected_lines
      let selected_text .= line . "\n"
    endfor
    return selected_text
  else
    return ''
  endif
endfunction
]]

return v
