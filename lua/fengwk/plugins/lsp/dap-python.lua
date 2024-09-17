-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Python
-- https://github.com/mfussenegger/nvim-dap-python
local ok, dap_python = pcall(require, "dap-python")
if not ok then
  return
end

local stdpath_data = vim.fn.stdpath("data")
-- 使用Mason安装
local debugpy_home = stdpath_data .. "/mason/packages/debugpy"
local debugpy_python = debugpy_home .. "/venv/bin/python"

dap_python.setup(debugpy_python)
