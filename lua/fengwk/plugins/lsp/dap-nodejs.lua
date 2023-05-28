-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Javascript
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local stdpath_data = vim.fn.stdpath("data")
local node_debug = stdpath_data .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js"

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { node_debug },
}

dap.configurations.javascript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}