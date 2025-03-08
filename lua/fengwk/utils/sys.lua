local sys = {}

local sysname = string.lower(vim.loop.os_uname().sysname)
if string.find(sysname, "windows") ~= nil then
  sys.os = "win"
elseif string.find(sysname, "linux") ~= nil then
  sys.os = "linux"
elseif string.find(sysname, "darwin") ~= nil then
  sys.os = "macos"
else
  sys.os = "wsl"
end

sys.open = function(uri)
  if vim.fn.has('mac') > 0 then
    sys.system("open '" .. uri .. "'", true)
  else
    sys.system("xdg-open '" .. uri .. "'", true)
  end
end

-- 用于替代vim.fn.system，保留了当前的执行环境
sys.system = function(cmd, background)
  if type(cmd) == "table" then
    cmd = table.concat(cmd, " ")
  end
  -- popen到标准输出，因此需将标准错误输出重定向
  cmd = cmd .. " 2>&1"
  if background then
    cmd = cmd .. " &"
  end
  local f = io.popen(cmd)
  if f == nil then
    return nil
  end
  if background then
    io.close(f)
    return nil
  else
    local res = f:read("*all")
    io.close(f)
    return res
  end
end

sys.is_tty = function()
  if vim.fn.has('mac') > 0 then
    return false
  end
  local tty = sys.system "tty"
  return tty and string.match(tty, "^/dev/tty") ~= nil
end

sys.now_ms = function()
  local nanos = sys.system("date +%s%N")
  return math.floor(nanos / 1e6)
end

return sys
