-- 这个函数提供调试功能
local function debug()
  vim.ui.input({ prompt = "MainClass: " }, function(main_class)
    require("dap").run({
      type = "java",
      request = "launch",
      name = "Launch Main Class",
      mainClass = main_class,
    })
  end)
end

-- 这个函数提供远程调试功能
local function do_remote_debug(host, port)
  if host and port then
    require("dap").run({
      type = "java",
      request = "attach",
      name = "Debug (Attach) - Remote",
      hostName = host,
      port = port,
    })
  end
end

-- 通过输入参数提供远程调试能力
local function remote_debug()
  vim.ui.input({ prompt = "Host: " }, function(host)
    vim.ui.input({ prompt = "Port: " }, function(port)
      do_remote_debug(host, port)
    end)
  end)
end

return {
  debug = debug,
  remote_debug = remote_debug,
}