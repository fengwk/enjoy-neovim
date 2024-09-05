local ok, tmux = pcall(require, "tmux")
if not ok then
  print("tmux not exists")
  return
end

-- move
vim.keymap.set("n", "<C-space>h", function() tmux.move_left() end)
vim.keymap.set("n", "<C-space>j", function() tmux.move_bottom() end)
vim.keymap.set("n", "<C-space>k", function() tmux.move_top() end)
vim.keymap.set("n", "<C-space>l", function() tmux.move_right() end)
-- resize
vim.keymap.set("n", "<A-Left>", function() tmux.resize_left() end)
vim.keymap.set("n", "<A-Down>", function() tmux.resize_bottom() end)
vim.keymap.set("n", "<A-Up>", function() tmux.resize_top() end)
vim.keymap.set("n", "<A-Right>", function() tmux.resize_right() end)

tmux.setup({
  copy_sync = {
    enable = false
  },
  navigation = {
    -- cycles to opposite pane while navigating into the border
    cycle_navigation = true,

    -- enables default keybindings (C-hjkl) for normal mode
    enable_default_keybindings = false,

    -- prevents unzoom tmux when navigating beyond vim border
    persist_zoom = false,
  },
  resize = {
    -- enables default keybindings (A-hjkl) for normal mode
    enable_default_keybindings = false,

    -- sets resize steps for x axis
    resize_step_x = 1,

    -- sets resize steps for y axis
    resize_step_y = 1,
  }
})
