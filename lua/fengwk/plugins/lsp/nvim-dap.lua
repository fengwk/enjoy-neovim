-- https://github.com/mfussenegger/nvim-dap

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

local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
  return
end

local M = {}

dap.defaults.fallback.terminal_win_cmd = "belowright 10new" -- 在下方打开dap terminal，10行高度

require("fengwk.plugins.lsp.nvim-dap-ui")
require("fengwk.plugins.lsp.nvim-dap-virtual-text")
require("fengwk.plugins.lsp.dap-cpp")
require("fengwk.plugins.lsp.dap-go")
require("fengwk.plugins.lsp.dap-neovim")
require("fengwk.plugins.lsp.dap-nodejs")
require("fengwk.plugins.lsp.dap-python")

local ok_mason_nvim_dap, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if ok_mason_nvim_dap then
  mason_nvim_dap.setup({
    -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
    ensure_installed = {
      "cppdbg",
      "delve",
      "node2",
      "python",
      "javadbg",
      "javatest",
    }
  })
end

M.setup_keymap = function(bufnr)
  -- 断点开关
  vim.keymap.set("n", "<leader>db", function()
    dap.toggle_breakpoint()
  end, { buffer = bufnr, desc = "Dap Breakpoint" })
  -- 条件断点
  vim.keymap.set("n", "<leader>dB", function()
    vim.ui.input({ prompt = "Condition: " }, function(cond)
      if cond then
        dap.set_breakpoint(cond)
      end
    end)
  end, { buffer = bufnr, desc = "Dap Breanpoint With Condition" })
  -- 清理所有断点
  vim.keymap.set("n", "<leader>dc", "<Cmd>lua require('dap').clear_breakpoints()<CR>", { buffer = bufnr, silent = true, desc = "Dap Clear Breakpoints" })
  -- 执行最后一次的run
  vim.keymap.set("n", "<leader>dl", "<Cmd>lua require('dap').run_last()<CR>", { buffer = bufnr, silent = true, desc = "Dap Run Last" })
  -- REPL开关
  vim.keymap.set("n", "<leader>dr", function()
    local current_win = vim.api.nvim_get_current_win()
    local current_width = vim.api.nvim_win_get_width(current_win)
    local width = math.max(15, math.ceil(current_width / 3))
    dap.repl.toggle({ width = width }, "rightbelow vsplit")
    vim.cmd("wincmd p") -- 聚焦窗口
  end, { buffer = bufnr, silent = true, desc = "Dap REPL" })
  vim.keymap.set("n", "<F5>", "<Cmd>lua require('dap').step_into()<CR>", { buffer = bufnr, silent = true, desc = "Dap Step Into" })
  vim.keymap.set("n", "<F6>", "<Cmd>lua require('dap').step_over()<CR>", { buffer = bufnr, silent = true, desc = "Dap Step Over" })
  vim.keymap.set("n", "<F7>", "<Cmd>lua require('dap').step_out()<CR>", { buffer = bufnr, silent = true, desc = "Dap Setp Out" })
  -- 这个命令同时可以启动debug
  vim.keymap.set("n", "<F8>", "<Cmd>lua require('dap').continue()<CR>", { buffer = bufnr, silent = true, desc = "Dap Continue" })
  -- 关闭当前session
  vim.keymap.set("n", "<leader>dt", "<Cmd>lua require('dap').terminate()<CR>", { buffer = bufnr, silent = true, desc = "Dap Terminate" })
end


-- 关闭terminal时自动删除缓冲区，避免无法在新的session中重新打开terminal
-- https://github.com/mfussenegger/nvim-dap/issues/603
vim.api.nvim_create_augroup("user_dap", { clear = true })
vim.api.nvim_create_autocmd("BufHidden",  {
  group = "user_dap",
  callback = function(arg)
    if arg and arg.file and string.find(arg.file, "[dap-terminal]", 1, true) then
      vim.schedule(function()
        vim.api.nvim_buf_delete(arg.buf, { force = true })
      end)
    end
  end
})

-- function _G._nvim_dap_toggle_ui(ui)
--   local widgets = require("dap.ui.widgets")
--   local sidebar = widgets.sidebar(widgets[ui])
--   sidebar.toggle()
-- end
--
-- -- 绑定ui快捷键
-- vim.cmd([[
-- command! DapUiScopes lua _G._nvim_dap_toggle_ui('scopes')
-- command! DapUiFrames lua _G._nvim_dap_toggle_ui('frames')
-- command! DapUiExpression lua _G._nvim_dap_toggle_ui('expression')
-- command! DapUiThreads lua _G._nvim_dap_toggle_ui('threads')
-- ]])

return M
