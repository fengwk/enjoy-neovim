-- https://github.com/akinsho/bufferline.nvim

local utils = require "user.utils"

-- :h bufferline-configuration
local config = { options = {} }

config.options.numbers = "ordinal"
config.options.diagnostics = "nvim_lsp"
config.options.always_show_bufferline = false -- 仅在打开多个缓冲区文件时显示bufferline
config.options.show_buffer_icons = true
config.options.show_buffer_close_icons = false
config.options.show_close_icon = false
config.options.offsets = {
  {
    filetype = "NvimTree",
    text = "File Explorer",
    highlight = "Directory",
    text_align = "left",
  }
}

-- 适配tty
if utils.is_tty() then
  config.options.show_buffer_icons = false
  config.options.show_buffer_close_icons = false
  config.options.show_close_icon = false
  config.options.show_buffer_default_icon = false
  config.options.color_icons = false
  config.options.indicator = {
    icon = '>',
    style = "icon",
  }
  config.options.modified_icon = 'M'
  config.options.left_trunc_marker = '<'
  config.options.right_trunc_marker = '>'
end

require("bufferline").setup(config)

vim.api.nvim_set_keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Bufferline Next" })
vim.api.nvim_set_keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true, desc = "Bufferline Prev" })
vim.api.nvim_set_keymap("n", "gb", ":BufferLinePick<CR>", { noremap = true, silent = true, desc = "Bufferline Pick" })
vim.api.nvim_set_keymap("n", "<leader>bc", "<Cmd>BufferLineCloseLeft<CR><Cmd>BufferLineCloseRight<CR>", { noremap = true, silent = true, desc = "Bufferline Close Other" })
vim.api.nvim_set_keymap("n", "<leader>1", "<Cmd>lua require('bufferline').go_to_buffer(1, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 1" })
vim.api.nvim_set_keymap("n", "<leader>2", "<Cmd>lua require('bufferline').go_to_buffer(2, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 2" })
vim.api.nvim_set_keymap("n", "<leader>3", "<Cmd>lua require('bufferline').go_to_buffer(3, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 3" })
vim.api.nvim_set_keymap("n", "<leader>4", "<Cmd>lua require('bufferline').go_to_buffer(4, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 4" })
vim.api.nvim_set_keymap("n", "<leader>5", "<Cmd>lua require('bufferline').go_to_buffer(5, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 5" })
vim.api.nvim_set_keymap("n", "<leader>6", "<Cmd>lua require('bufferline').go_to_buffer(6, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 6" })
vim.api.nvim_set_keymap("n", "<leader>7", "<Cmd>lua require('bufferline').go_to_buffer(7, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 7" })
vim.api.nvim_set_keymap("n", "<leader>8", "<Cmd>lua require('bufferline').go_to_buffer(8, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 8" })
vim.api.nvim_set_keymap("n", "<leader>9", "<Cmd>lua require('bufferline').go_to_buffer(9, true)<CR>", { noremap = true, silent = true, desc = "Bufferline Goto 9" })