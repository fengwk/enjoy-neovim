-- https://github.com/lewis6991/gitsigns.nvim

local gitsigns = require "gitsigns"
local utils = require "user.utils"

-- 适配tty
if utils.is_tty() then
  return
end
-- if utils.is_tty() then
--   config.signs = {
--     add          = {hl = 'GitSignsAdd'   , text = 'a', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
--     change       = {hl = 'GitSignsChange', text = 'm', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
--     delete       = {hl = 'GitSignsDelete', text = 'd', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
--     topdelete    = {hl = 'GitSignsDelete', text = 'd', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
--     changedelete = {hl = 'GitSignsChange', text = 'm', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
--   }
-- end

local config = {}

-- blame
config.current_line_blame = false
config.current_line_blame_opts = {
  virt_text = true,
  virt_text_pos = "right_align", -- "eol" | "overlay" | "right_align"
  delay = 0,
  ignore_whitespace = false,
}
config.current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>"


gitsigns.setup(config)

-- 打开/关闭责任人
vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { noremap = true, silent = true, desc = "Show Git Blame" })