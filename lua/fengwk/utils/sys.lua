local sys = {}

local os = {
  ["Windows"] = "win",
  ["Linux"] = "linux",
  ["Darwin"] = "macos",
}
sys.os = os[vim.loop.os_uname().sysname] or "wsl"

-- 用于替代vim.fn.system，保留了当前的执行环境
sys.system = function(cmd)
  if type(cmd) == "table" then
    cmd = table.concat(cmd, " ")
  end
  -- popen到标准输出，因此需将标准错误输出重定向
  local f = io.popen(cmd .. " 2>&1")
  if f == nil then
    return nil
  end
  local res = f:read("*all")
  io.close(f)
  return res
end

sys.is_tty = function()
  local tty = sys.system "tty"
  return tty and string.match(tty, "^/dev/tty") ~= nil
end

return sys
