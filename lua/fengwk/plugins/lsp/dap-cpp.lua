-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local stdpath_data = vim.fn.stdpath("data")
-- 使用Mason安装
local open_debug_ad7 = stdpath_data .. "/mason/bin/OpenDebugAD7"

dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = open_debug_ad7,
}

-- 调试文件需要先使用gcc -g生成
local conf = {
  {
    name = "Launch file with program",
    type = "cppdbg",
    request = "launch",
    program = function()
      local p = nil
      vim.ui.input({ prompt = "Program Path (Comple With -g): ", default = vim.fn.getcwd() .. "/"}, function(input)
        if input then
          p = input
        end
      end)
      return p
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
  },
  {
    name = "Attach to gdb Server :12345",
    type = "cppdbg",
    request = "launch",
    MIMode = "gdb",
    miDebuggerServerAddress = "localhost:12345",
    miDebuggerPath = "/usr/bin/gdb",
    cwd = "${workspaceFolder}",
    program = function()
      local p = nil
      vim.ui.input({ prompt = "Path to executable: ", default = vim.fn.getcwd() .. "/"}, function(input)
        if input then
          p = input
        end
      end)
      return p
    end,
  },
}

dap.configurations.cpp = conf
dap.configurations.c = conf
