local M = {}

local function remote_debug(host, port)
  require 'dap'.run({
    type = 'java',
    request = 'attach',
    name = 'Debug (Attach) - Remote',
    hostName = host,
    port = port,
  })
end

M.remote_debug_by_input = function()
  vim.ui.input({ prompt = "Host: " }, function(host)
    vim.ui.input({ prompt = "Port: " }, function(port)
      remote_debug(host, port)
    end)
  end)
end

return M