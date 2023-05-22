-- https://github.com/lewis6991/gitsigns.nvim

local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  vim.notify("gitsigns can not be required.")
  return
end

local utils = require("fengwk.utils")

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

gitsigns.setup({
  current_line_blame = false, -- 默认情况下是否展示blame
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "right_align", -- "eol" | "overlay" | "right_align"
    delay = 0,
    ignore_whitespace = false,
  },
})

-- blame开关
vim.keymap.set("n", "<leader>gb", "<Cmd>Gitsigns toggle_current_line_blame<CR>", { silent = true, desc = "Toggle Git Blame" })