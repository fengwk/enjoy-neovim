local lang = require "fengwk.utils.lang"

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
  -- 如果文件大小超过阈值则不高亮
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > v.large_fsize then
    return true
  end
  -- 如果文件行数超过阈值则不高亮
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count and line_count > v.large_flines then
    return true
  end
  return false
end

-- 获取选中的内容
v.selection_lines = function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]
  local start_col = start_pos[3]
  local end_col = end_pos[3]
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local selection = {}
  for i, line in ipairs(lines) do
    if i == 1 then
      line = line:sub(start_col)
    elseif i == #lines then
      line = line:sub(1, end_col - 1)
    end
    table.insert(selection, line)
  end
  return selection
end

v.cd = function(root, filename)
  if not lang.empty_str(root) and vim.fn.getcwd() ~= root then
    root = vim.fn.expand(root)
    vim.cmd("cd " .. root)
    local t_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
    if t_ok then
      nvim_tree_api.tree.change_root(root) -- 主动修改nvim-tree root，否则切换会出现问题
    end
  end
  if not lang.empty_str(filename) then
    filename = vim.fn.expand(filename)
    -- 自动切换到nvim-tree聚焦到打开的文件
    local ok_finders_find_file, finders_find_file = pcall(require, "nvim-tree.actions.finders.find-file")
    if ok_finders_find_file then
      finders_find_file.fn(filename)
    end
  end
end

return v
