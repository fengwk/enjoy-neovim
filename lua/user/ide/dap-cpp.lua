-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
local dap = require "dap"

local stdpath_data = vim.fn.stdpath("data")
-- 使用Mason安装
local open_debug_ad7 = stdpath_data .. "/mason/bin/OpenDebugAD7"

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = open_debug_ad7,
}

-- 调试文件需要使用gcc -g生成
local conf = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      local p = nil
      vim.ui.input({ prompt = "Path to executable: ", default = vim.fn.getcwd() .. "/"}, function(input)
        p = input
      end)
      return p
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      local p = nil
      vim.ui.input({ prompt = "Path to executable: ", default = vim.fn.getcwd() .. "/"}, function(input)
        p = input
      end)
      return p
    end,
  },
}

dap.configurations.cpp = conf
dap.configurations.c = conf