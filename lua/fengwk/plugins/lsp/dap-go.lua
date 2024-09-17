-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly
-- https://github.com/leoluz/nvim-dap-go
local ok, dap_go = pcall(require, "dap-go")
if not ok then
  return
end
dap_go.setup()
