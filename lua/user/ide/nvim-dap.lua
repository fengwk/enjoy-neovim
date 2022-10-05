-- https://github.com/mfussenegger/nvim-dap
-- local dap = require "dap"
-- local utils = require "user.utils"

-- dap.set_log_level("DEBUG")

-- :h dap-run
-- :h dap-configuration
-- local function dap_launch()
--   dap.run({
--     type = utils.get_current_filetype(),
--     request = "launch",
--   })
-- end
--
-- local function dap_attach()
--   dap.run({
--     type = utils.get_current_filetype(),
--     request = "attach",
--   })
-- end

-- https://github.com/Weissle/persistent-breakpoints.nvim
-- 持久化断点
-- require("persistent-breakpoints").setup{
-- 	save_dir = vim.fn.stdpath("cache") .. "/persistent-breakpoints",
-- 	perf_record = false,
-- }
-- vim.api.nvim_create_autocmd({"BufReadPost"},{ callback = require("persistent-breakpoints.api").load_breakpoints })
-- vim.keymap.set("n", "<leader>db", "<Cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>", { noremap = true, silent = true, desc = "Dap Breakpoint" })
-- vim.keymap.set("n", "<leader>dB", function()
--   vim.ui.input({ prompt = "Condition: " }, function(cond)
--     require("persistent-breakpoints.api").set_breakpoint(cond)
--   end)
-- end, { noremap = true, silent = true, desc = "Dap Breanpoint With Condition" })
-- vim.keymap.set("n", "<leader>dc", "<Cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<CR>", { noremap = true, silent = true, desc = "Dap Clear Breakpoints" })

vim.keymap.set("n", "<leader>db", "<Cmd>lua require('dap').toggle_breakpoint()<CR>", { noremap = true, silent = true, desc = "Dap Breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  vim.ui.input({ prompt = "Condition: " }, function(cond)
    require("dap").set_breakpoint(cond)
  end)
end, { noremap = true, silent = true, desc = "Dap Breanpoint With Condition" })
vim.keymap.set("n", "<leader>dc", "<Cmd>lua require('dap').clear_breakpoints()<CR>", { noremap = true, silent = true, desc = "Dap Clear Breakpoints" })

vim.keymap.set("n", "<leader>du", "<Cmd>lua require('dapui').toggle({reset=true})<CR>", { noremap = true, silent = true, desc = "Dap UI Toggle" })
-- vim.keymap.set("n", "<leader>dr", "<Cmd>lua require('dap').repl.open()<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>dl", "lua require'dap'.run_last()<cr>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<F5>", "<Cmd>lua require('dap').step_into()<CR>", { noremap = true, silent = true, desc = "Dap Step Into" })
vim.keymap.set("n", "<F6>", "<Cmd>lua require('dap').step_over()<CR>", { noremap = true, silent = true, desc = "Dap Step Over" })
vim.keymap.set("n", "<F7>", "<Cmd>lua require('dap').step_out()<CR>", { noremap = true, silent = true, desc = "Dap Setp Out" })
-- 这个命令同时可以启动debug
vim.keymap.set("n", "<F8>", "<Cmd>lua require('dap').continue()<CR>", { noremap = true, silent = true, desc = "Dap Continue" })
vim.keymap.set("n", "<leader>dt", "<Cmd>lua require('dap').terminate()<CR>", { noremap = true, silent = true, desc = "Dap Terminate" })