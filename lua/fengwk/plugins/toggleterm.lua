-- https://github.com/akinsho/toggleterm.nvim

local toggleterm = require("toggleterm")
local utils = require("fengwk.utils")

-- 在当前缓冲区所在文件夹的路径，使用指定方向打开终端
-- @param direction horizontal|vertical|float
function _G._toggleterm_toggle_curdir(direction)
  vim.api.nvim_command("ToggleTerm direction=" .. direction .. " dir=" .. vim.fn.expand("%:p:h"))
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 0.25 -- 如果是水平方向打开，占25%
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.3 -- 如果是垂直方向打开，占30%
    end
  end,
  shell = utils.sys.os == "win" and "powershell.exe" or vim.o.shell, -- 在window下指定powershell，否则使用vim默认的shell
})

-- 设置键位映射
vim.keymap.set({ "n", "t" }, "``", "<Cmd>ToggleTerm direction=horizontal<CR>", { silent = true, desc = "Toggle Term In CWD" })
vim.keymap.set({ "n", "t" }, "`<Enter>", function()
  vim.api.nvim_command("ToggleTerm direction=horizontal dir=" .. vim.fn.expand("%:p:h"))
end, { desc = "Toggle Term In Current Buffer Dir" })
