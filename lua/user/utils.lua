local M = {}

-- os_name当前操作系统的名称：win、wsl、linux
local os_name, fs_separator
if vim.fn.has("win32") == 1 then
  os_name = "win"
  fs_separator = "\\"
elseif vim.fn.has("wsl") == 1 then
  os_name = "wsl"
  fs_separator = "/"
else
  os_name = "linux"
  fs_separator = "/"
end

-- 使用当前操作系统的文件分隔符连接文件路径的多个部分
-- @param array 文件系统路径部分的数组
local function fs_concat(parts)
  if parts == nil or #parts == 0 then
    return ""
  end
  local p = parts[1]
  for i = 2, #parts do
    p = p .. fs_separator .. parts[i]
  end
  return p
end

-- 检查s与pats是否匹配
local function is_match(s, parts)
  local lfs = require("lfs")
  for file in lfs.dir(s) do
       -- 过滤"."和".."目录
       if file ~= "." and file ~= ".." then
         for _, p in ipairs(parts) do
           if string.match(file, p) then
             return true
           end
         end
       end
   end
   return false
end

-- 从当前文件目录向上查找与pats中任一项匹配的文件夹
-- @param pats array 必须，模式数组
-- @param stop number 可选，匹配到几次模式停止，如果是-1那么一直向上查找直到最后一个模式匹配的路径，默认为-1
local function find_root_dir (pats, stop)
  if stop == nil then stop = -1 end
  -- 找到模式匹配的文件夹路径
  local found_dir_name = nil
  -- 当前文件夹的路径
  local cur_dir_name = vim.fn.expand("%:p:h")
  -- 找到模式匹配的文件夹m次
  local m = 0
  -- 主要的逻辑是在当前目录非空前，并且找到的次数不满足stop前一直查找
  -- 另外的逻辑是排除一些特殊情况的干扰，比如jdt路径
  while cur_dir_name ~= "" and (stop <= 0 or m < stop) and string.match(cur_dir_name, "^jdt://") == nil do
    if is_match(cur_dir_name, pats) then
      m = m + 1
      found_dir_name = cur_dir_name
    end
    cur_dir_name = string.gsub(cur_dir_name, "/[^/]+$", "", 1)
  end
  return found_dir_name
end

-- 执行命令并返回输出
-- @param cmd string 必须，命令内容
local function exec_cmd(cmd)
  -- popen到标准输出，因此需将标准错误输出重定向
  local f = io.popen(cmd .. " 2>&1")
  if f == nil then
    return nil
  end
  local res = f:read("*all")
  io.close(f)
  return res
end

-- 检查当前是否为tty环境
local function is_tty()
  local tty = exec_cmd("tty")
  return tty ~= nil and string.match(tty, "^/dev/tty") ~= nil
end

-- 根据环境require不同的配置
-- @param conf_name string 必须，配置名称
local function require_conf (conf_name)
  if is_tty() then
    local ok, m = pcall(require, "user.conf-tty." .. conf_name)
    print(ok, m)
    if ok then
      return m
    end
  end
  return require("user.conf." .. conf_name)
end

-- 如果v不是table，将其适配为table array
local function adapt_array(v)
  if v == nil then
    return {}
  elseif type(v) == "table" then
    return v
  else
    return { v }
  end
end

-- 获取当前文件类型
local function get_current_filetype()
  return vim.bo.filetype
end

M.os_name = os_name
M.fs_separator = fs_separator
M.exec_cmd = exec_cmd
M.fs_concat = fs_concat
M.find_root_dir = find_root_dir
M.is_tty = is_tty
M.require_conf = require_conf
M.adapt_array = adapt_array
M.get_current_filetype = get_current_filetype

return M