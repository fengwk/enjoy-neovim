-- https://github.com/akinsho/toggleterm.nvim

local toggleterm = require("toggleterm")
local utils = require("fengwk.utils")

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 0.25 -- 如果是水平方向打开，占25%
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.3 -- 如果是垂直方向打开，占30%
    end
  end,
  float_opts = {
    border = "curved",
    width = function()
      return math.ceil(vim.o.columns * 0.7)
    end,
    height = function()
      return math.ceil(vim.o.lines * 0.65)
    end,
    winblend = vim.o.winblend,
  },
  shell = utils.sys.os == "win" and "powershell.exe" or vim.o.shell, -- 在window下指定powershell，否则使用vim默认的shell
})

-- 设置键位映射
vim.keymap.set({ "n", "t" }, "``", function ()
  vim.api.nvim_command("ToggleTerm direction=float")
end, { desc = "Toggle Term In CWD" })
vim.keymap.set({ "n", "t" }, "`<Enter>", function()
  vim.api.nvim_command("ToggleTerm direction=float" .. " dir=" .. vim.fn.expand("%:p:h"))
end, { desc = "Toggle Term In Current Buffer Dir" })
