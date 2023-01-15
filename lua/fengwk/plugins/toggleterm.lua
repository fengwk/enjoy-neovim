-- https://github.com/akinsho/toggleterm.nvim

local toggleterm = require "toggleterm"
local utils = require "fengwk.utils"

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
  -- open_mapping = [[<A-`>]],
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
  direction = "horizontal", -- vertical | horizontal | tab | float
  close_on_exit = true, -- close the terminal window when the process exits
  shell = utils.os_name == "win" and "powershell.exe" or vim.o.shell, -- change the default shell
  auto_scroll = true, -- automatically scroll to the bottom on terminal outpu
})

-- 在cwd路径打开
local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "t" }, "``", "<Cmd>ToggleTerm direction=horizontal<CR>", opts)
-- 在当前缓冲区所在路径打开
vim.keymap.set({ "n", "t" }, "`<Enter>", function()
  vim.api.nvim_command("ToggleTerm direction=horizontal dir=" .. vim.fn.expand("%:p:h"))
end, opts)
-- vim.api.nvim_set_keymap("n", "~", "<Cmd>ToggleTerm direction=horizontal<CR>", opts)
-- vim.api.nvim_set_keymap("t", "~", "<Cmd>ToggleTerm direction=horizontal<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<A-`>", "<Cmd>ToggleTerm direction=horizontal<CR>", opts)
-- vim.api.nvim_set_keymap("t", "<A-`>", "<Cmd>ToggleTerm direction=horizontal<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<A-~>", "<Cmd>call v:lua._toggleterm_toggle_curdir('float')<CR>", opts)
-- vim.api.nvim_set_keymap("n", "~", "<Cmd>ToggleTerm direction=float<CR>", opts)
-- vim.api.nvim_set_keymap("t", "~", "<Cmd>ToggleTerm direction=float<CR>", opts)
-- vim.api.nvim_set_keymap("n", "tv", ":ToggleTerm direction=vertical dir=" .. termdir .."<CR>", opts)
-- vim.api.nvim_set_keymap("n", "tf", ":ToggleTerm direction=float dir=" .. termdir .."<CR>", opts)