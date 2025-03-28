local sys = require "fengwk.utils.sys"

local fs = {}

local sysname = string.lower(vim.loop.os_uname().sysname)
if string.find(sysname, "windows") ~= nil then
  fs.sp = "\\"
else
  fs.sp = "/"
end

local function regularize(path)
  return string.gsub(path, "/", fs.sp)
end

local function to_table(...)
  local tb = {}
  for _, v in ipairs({ ... }) do
    table.insert(tb, v)
  end
  return tb
end

fs.join = function(...)
  local args = to_table(...)
  local p = table.concat(args, fs.sp)
  return regularize(p)
end

fs.read_file = function(filename)
  local file, _ = io.open(filename, "r")
  if file ~= nil then       -- err == nil 说明文件存在
    local res = file:read() -- 读取状态值
    file:close()
    return res
  end
  return nil
end

fs.write_file = function(filename, content)
  local file, _ = io.open(filename, "w")
  if file ~= nil then -- err == nil 说明文件存在
    file:write(content)
    file:close()
  end
end

-- 检查dir是否与parts匹配
local function match_dir(dir, parts)
  for _, p in ipairs(parts) do
    if p ~= nil and dir == p then
      return true
    end
  end
  return false
end


-- 检查s与pats是否匹配
local function match_file(dir, parts)
  local filelist = vim.split(vim.fn.glob(fs.join(dir, "*")), "\n")
  for _, file in pairs(filelist) do
    local filetail = vim.fn.fnamemodify(file, ":t")
    -- 过滤"."和".."目录
    if filetail ~= "." and filetail ~= ".." then
      for _, p in ipairs(parts) do
        if p ~= nil and string.match(filetail, "^" .. p .. "$") ~= nil then
          return true
        end
      end
    end
  end
  return false
end


-- 迭代路径直到根
-- @param path 起始路径
-- @param iter_func 迭代函数，如果返回false则提前退出迭代
fs.iter_path_to_root = function(path, iter_func)
  local cur_path = vim.fn.expand(path)
  while cur_path ~= "" do
    if not iter_func(cur_path) then
      return
    end

    local next_path = vim.fn.fnamemodify(cur_path, ":h")
    -- 在windows上根目录为：nextpath == curpath
    cur_path = (next_path == cur_path) and "" or next_path
  end
end

fs.is_uri = function(s)
  return string.match(s, "^[^:]+://") ~= nil
end

-- 从当前文件目录向上查找与pats中任一项匹配的文件夹
-- @param parts list 必须，模式数组
-- @param stop number 可选，匹配到几次模式停止，如果是-1那么一直向上查找直到最后一个模式匹配的路径，默认为-1
fs.root_dir = function(parts, stop)
  if stop == nil then stop = -1 end
  -- 找到模式匹配的文件夹路径
  local found_dir = nil
  -- 当前文件夹的路径
  local curdir = vim.fn.expand("%:p:h")
  -- 找到模式匹配的文件夹m次
  local m = 0
  -- 主要的逻辑是在当前目录非空前，并且找到的次数不满足stop前一直查找
  -- 另外的逻辑是排除一些特殊情况的干扰，比如jdt路径
  fs.iter_path_to_root(curdir, function(cur_path)
    if (stop > 0 and m >= stop) or fs.is_uri(cur_path) then
      return false
    end
    if match_dir(cur_path, parts) or match_file(cur_path, parts) then
      m = m + 1
      found_dir = cur_path
    end
    return true
  end)
  return found_dir
end

-- 检查文件是否存在
fs.exists = function(filename)
  return filename and vim.loop.fs_stat(filename) ~= nil
end

fs.is_dir = function(path)
  if not path then
    return false
  end
  local stat = vim.loop.fs_stat(path)
  if stat and stat.type == "directory" then
    return true
  end
  return false
end

fs.parent = function(path)
  local p = vim.fn.fnamemodify(path, ":t")
  return vim.fn.expand(p)
end

fs.ensure_dir = function(dir)
  if fs.exists(dir) then
    return
  end
  vim.fn.system { "mkdir", "-p", dir }
end

-- 转义filename
fs.escape_filename = function(filename)
  local name = string.gsub(filename, fs.sp, "__")
  if sys.os == "win" then
    name = string.gsub(name, ":", "++")
  end
  return name
end

fs.write_data = function(filename, data)
  local json = vim.fn.json_encode(data)
  fs.write_file(filename, json)
end

fs.read_data = function(filename)
  local json = fs.read_file(filename)
  if not json then
    return nil
  end
  return vim.fn.json_decode(json)
end

-- 规范化路径
-- 1. 路径将被解析规范的
-- 2. 如果存在/a/路径将被解析为/a
fs.regularize_path = function(path)
  if path then
    path = vim.fn.expand(path)
    if path and #path > 0 and path:sub(-1) == fs.sp then
      path = path:sub(1, -2)
    end
    -- windows不区分大小写处理时全部转为小写
    if sys.os == "win" then
      path = string.lower(path)
    end
  end
  return path
end

fs.path_equals = function(path1, path2)
  return fs.regularize_path(path1) == fs.regularize_path(path2)
end

return fs
