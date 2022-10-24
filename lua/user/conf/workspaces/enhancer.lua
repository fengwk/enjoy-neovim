local M = {}

local ok, ws = pcall(require, "workspaces")
if not ok then
  return M
end

local utils = require("user.utils")

local function get_path_to_ws_name_map()
  local ws_list = ws.get()
  if ws_list == nil or #ws_list == 0 then
    return
  end
  local path_to_ws_name = {}
  for _, item in pairs(ws_list) do
    path_to_ws_name[item.path] = item.name
  end
  return path_to_ws_name
end

-- 获取path路径的可加载工作空间
local function get_can_loaded_ws(path)
  -- 获取路径到工作空间名称的映射
  local path_to_ws_name = get_path_to_ws_name_map()
  if path_to_ws_name == nil then
    return nil, nil
  end
  -- 检查是否有匹配的工作空间
  local can_loaded_ws_name = nil
  local can_loaded_ws_path = nil
  utils.iter_path_until_root(path, function(cur_path)
    local ws_name = path_to_ws_name[cur_path .. utils.fs_separator]
    if ws_name ~= nil then
      can_loaded_ws_name = ws_name
      can_loaded_ws_path = cur_path
      return false
    end
    return true
  end)
  return can_loaded_ws_name, can_loaded_ws_path
end

-- 获取path路径的记录文件，如果path路径没有相应工作空间则返回nil
local function get_record_file(ws_dir, path)
  local can_loaded_ws_name, _ = get_can_loaded_ws(path)
  if can_loaded_ws_name == nil then
    return
  end
  local record_name = "buf#" .. can_loaded_ws_name
  local record_file = utils.fs_concat({ ws_dir, record_name })
  return record_file
end

M.auto_load_ws = function(ws_dir)
  local buf_path = vim.fn.expand("%:p")
  if buf_path == nil or buf_path == "" then -- 只在无名缓冲区自动加载

    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count == 1 and vim.cmd("echo getline(1)") == "" then -- 仅在无内容时加载
      M.reload_ws_buf(ws_dir)
    end
  end
end

-- 记录当前工作空间的缓冲区
M.record_ws_buf = function(ws_dir)
  local buf_path = vim.fn.expand("%:p")
  if buf_path == nil or buf_path == "" or utils.is_uri(buf_path) or utils.is_not_file_ft() then
    return
  end

  local record_file = get_record_file(ws_dir, buf_path)
  if record_file == nil then
    return
  end
  utils.write_file(record_file, buf_path)
end

-- 打开当前工作空间记录的缓冲区
M.reload_ws_buf = function(ws_dir)
  local record_file = get_record_file(ws_dir, vim.fn.getcwd())
  if record_file == nil or record_file == "" then
    return
  end
  local buf_path = utils.read_file(record_file)
  if buf_path ~= nil then
    vim.schedule(function()
      pcall(function()
        -- 如果缓冲区冲突此处会出现异常，使用pcall忽略
        vim.api.nvim_command("edit " .. buf_path)
      end)
    end)
  end
end

return M