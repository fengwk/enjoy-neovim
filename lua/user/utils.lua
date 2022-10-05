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
-- @param parts list 文件系统路径部分的数组
local function fs_concat(parts)
  if parts == nil or #parts == 0 then
    return ""
  end
  local res = ""
  local add_sp = false
  for _, p in pairs(parts) do
    if p ~= nil then
      if add_sp then
        res = res .. fs_separator
      end
      res = res .. p
      add_sp = true
    end
  end
  return res
end

-- 检查s与pats是否匹配
local function is_match(s, parts)
  local file_list = vim.split(vim.fn.glob(s .. fs_separator .. "*"), "\n")
  for _, file in pairs(file_list) do
    file = vim.fn.fnamemodify(file, ":t")
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
-- @param pats list 必须，模式数组
-- @param stop number 可选，匹配到几次模式停止，如果是-1那么一直向上查找直到最后一个模式匹配的路径，默认为-1
local function find_root_dir(pats, stop)
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
    local next_dir_name = vim.fn.fnamemodify(cur_dir_name, ":h")
    -- 在windows上根目录为：next_dir_name == cur_dir_name
    cur_dir_name = (next_dir_name == cur_dir_name) and "" or next_dir_name
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
local function require_conf(conf_name)
  if is_tty() then
    local ok, m = pcall(require, "user.conf-tty." .. conf_name)
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

-- 过滤列表中符合条件的元素
local function table_filter(tab, predicate)
  local new_tab = {}
  for k, v in pairs(tab) do
    if predicate({ key = k, value = v }) then
      new_tab[k] = v
    end
  end
  return new_tab
end

-- 检查元素非空
local function non_nil(v)
  return v ~= nil
end

-- 检查列表中是否包含指定元素
-- @param list list 指定列表
-- @param other any|list 比较的元素或列表
local function list_contains(list, other)
  for _, v1 in pairs(list) do
    for _, v2 in pairs(adapt_array(other)) do
      if v1 == v2 then
        return true
      end
    end
  end
  return false
end

-- 合并列表
local function list_merge(l1, l2)
  if l1 == nil then
    return l2
  end
  if l2 == nil then
    return l1
  end
  local new_list = {}
  for _, v in ipairs(l1) do
    table.insert(new_list, v)
  end
  for _, v in ipairs(l2) do
    table.insert(new_list, v)
  end
  return new_list
end

-- 检查文件是否存在
function exists_file(filename)
  local file = io.open(filename, "rb")
  if file then
    file:close()
  end
  return file ~= nil
end

-- 确保目录存在
local function ensure_mkdir(dir)
  if exists_file(dir) then
    return
  end
  -- 暂时仅支持安装linux utils的windows
  exec_cmd("mkdir -p " .. dir)
end

-- 读取文件信息
local function read_file(filename)
  local file, _ = io.open(filename, "r")
  if file ~= nil then -- err == nil 说明文件存在
    local res = file:read() -- 读取状态值
    file:close()
    return res
  end
  return nil
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
M.table_filter = table_filter
M.non_nil = non_nil
M.list_contains = list_contains
M.list_merge = list_merge
M.exists_file = exists_file
M.ensure_mkdir = ensure_mkdir
M.read_file = read_file
return M