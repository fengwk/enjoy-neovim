-- https://github.com/kyazdani42/nvim-tree.lua

local utils = require "user.utils"
-- :h nvim-tree-setup
local config = {}

config.sort_by = "case_sensitive"
config.sync_root_with_cwd = true -- 使root与cwd保持一致

config.view = {
  adaptive_size = true, -- 根据文件名自适应宽度
  -- number = true,
  -- relativenumber = true,
  mappings = {
    custom_only = true,
    list = {
      { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
      { key = "<C-e>",                          action = "edit_in_place" },
      { key = "O",                              action = "edit_no_picker" },
      { key = { "<C-]>", "<2-RightMouse>" },    action = "cd" },
      { key = "<C-v>",                          action = "vsplit" },
      { key = "<C-x>",                          action = "split" },
      { key = "<C-t>",                          action = "tabnew" },
      -- { key = "<",                              action = "prev_sibling" },
      -- { key = ">",                              action = "next_sibling" },
      { key = "P",                              action = "parent_node" },
      { key = "<BS>",                           action = "close_node" },
      { key = "<Tab>",                          action = "preview" },
      { key = "K",                              action = "first_sibling" },
      { key = "J",                              action = "last_sibling" },
      { key = "I",                              action = "toggle_git_ignored" },
      { key = "H",                              action = "toggle_dotfiles" },
      { key = "U",                              action = "toggle_custom" },
      { key = "R",                              action = "refresh" },
      { key = "a",                              action = "create" },
      { key = "d",                              action = "remove" },
      { key = "D",                              action = "trash" },
      { key = "r",                              action = "rename" },
      { key = "<C-r>",                          action = "full_rename" },
      { key = "x",                              action = "cut" },
      { key = "c",                              action = "copy" },
      { key = "p",                              action = "paste" },
      { key = "y",                              action = "copy_name" },
      { key = "Y",                              action = "copy_path" },
      { key = "gy",                             action = "copy_absolute_path" },
      { key = "[e",                             action = "prev_diag_item" },
      { key = "[c",                             action = "prev_git_item" },
      { key = "]e",                             action = "next_diag_item" },
      { key = "]c",                             action = "next_git_item" },
      { key = "-",                              action = "dir_up" },
      { key = "s",                              action = "system_open" },
      { key = "f",                              action = "live_filter" },
      { key = "F",                              action = "clear_live_filter" },
      -- { key = "q",                              action = "close" },
      { key = "W",                              action = "collapse_all" },
      { key = "E",                              action = "expand_all" },
      { key = "S",                              action = "search_node" },
      { key = ".",                              action = "run_file_command" },
      { key = "<C-k>",                          action = "toggle_file_info" },
      { key = "g?",                             action = "toggle_help" },
      { key = "m",                              action = "toggle_mark" },
      { key = "bmv",                            action = "bulk_move" },
    },
  },
}

config.renderer = {
  group_empty = true,
}

config.filters = {
  -- dotfiles = true,
}

-- 适配tty
if utils.is_tty() then
  config.renderer.icons = {
    webdev_colors = false,
    show = { file = false, folder = true, folder_arrow = false, git = false },
    glyphs = { default = "f", symlink = "l", bookmark = "b", folder = { arrow_closed = ">", arrow_open = "v", default = "d", open = "d", empty = "d", empty_open = "d", symlink = "l", symlink_open = "l" } }
  }
end

require("nvim-tree").setup(config)

-- 展开或关闭NvimTree，如果是展开将定位到文件对应的NvimTree位置
vim.api.nvim_set_keymap("n", "tt", "<Cmd>NvimTreeFindFileToggle<CR>", { noremap = true, silent = true, desc = "NvimTree Find File Toggle" })

-- 定位到文件对应的NvimTree位置
vim.api.nvim_set_keymap("n", "tf", "<Cmd>NvimTreeFindFile<CR>", { noremap = true, silent = true, desc = "NvimTree Find File" })