-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Python
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local stdpath_data = vim.fn.stdpath("data")
-- 使用Mason安装
local debugpy_home = stdpath_data .. "/mason/packages/debugpy"
local python = debugpy_home .. "/venv/bin/python"

dap.adapters.python = {
  type = "executable",
  command = python,
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = "launch",
    name = "Launch file",

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}", -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      return "/usr/bin/python"
    end;
  },
}