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
local function remote_debug(host, port)
  require("dap").run({
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = host,
    port = port,
  })
end

-- 通过输入参数提供远程调试能力
local function remote_debug_by_input()
  vim.ui.input({ prompt = "Host: " }, function(host)
    vim.ui.input({ prompt = "Port: " }, function(port)
      remote_debug(host, port)
    end)
  end)
end

return {
  debug = debug,
  remote_debug_by_input = remote_debug_by_input,
}