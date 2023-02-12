-- https://github.com/kyazdani42/nvim-tree.lua

local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
  return
end

local utils = require("fengwk.utils")

-- :h nvim-tree-setup
local config = {
  sort_by = "case_sensitive", -- 文件按照字符排序，大小写敏感
  sync_root_with_cwd = true, -- 使root与cwd保持一致
  view = {
    adaptive_size = true, -- 根据文件名自适应宽度
    -- number = true, -- 等效于 set nu
    -- relativenumber = true, -- 等效于 set rnu
    mappings = {
      custom_only = true, -- 仅使用自定义快捷键映射
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
        -- { key = "<C-k>",                          action = "toggle_file_info" },
        { key = "gk",                             action = "toggle_file_info" },
        { key = "g?",                             action = "toggle_help" },
        { key = "m",                              action = "toggle_mark" },
        { key = "bmv",                            action = "bulk_move" },
      },
    },
  },
  system_open = {
	  cmd = "xdg-open",
  },
  renderer = {
    add_trailing = false,
    group_empty = true, -- 这个选项如果为true能将空白的目录收起成一行，例如/fun/fengwk/utils作为一个整体成为单独一行
    highlight_git = false,
    full_name = false,
    highlight_opened_files = "none",
    root_folder_modifier = ":~",
    indent_width = 2,
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "",
          untracked = "",
          deleted = "✖",
          ignored = "",
        },
      },
    },
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    symlink_destination = true,
  },
  filters = {
    -- dotfiles = true, -- 过滤.文件
  },
}

-- 适配tty
if utils.is_tty() then
  config.renderer.icons = {
    webdev_colors = false,
    show = { file = false, folder = true, folder_arrow = false, git = false },
    glyphs = { default = "f", symlink = "l", bookmark = "b", folder = { arrow_closed = ">", arrow_open = "v", default = "d", open = "d", empty = "d", empty_open = "d", symlink = "l", symlink_open = "l" } }
  }
end

nvim_tree.setup(config)

-- 展开或关闭NvimTree，如果是展开将定位到文件对应的NvimTree位置
vim.keymap.set("n", "<leader>e", function()
  nvim_tree.toggle({
    focus = true,
    find_file = true,
  })
end, { desc = "NvimTree Find File Toggle" })