-- https://github.com/gcmt/wildfire.vim
vim.g.wildfire_objects = {
  ["*"] = {
    "i'",
    'i"',
    "i)",
    "i]",
    "i}",
    "ip",
    "it",
    -- treesitter-object
    "ia",
    "if",
    "ic",
    "iC",
  },
  ["html,xml"] = {
    "it",
    "at",
  }
}

-- This selects the next closest text object.
vim.keymap.set({ "n", "x" }, "<Enter>", "<Plug>(wildfire-fuel)", {})
-- This selects the previous closest text object.
-- vim.keymap.set("x", "<BS>", "<Plug>(wildfire-water)", {})
vim.keymap.set("x", "<leader><Enter>", "<Plug>(wildfire-water)", {})
-- quick select，禁用这个方法，在neovim中使用存在bug？导致了错误的选择
-- vim.keymap.set({ "n", "x" }, "<leader><Enter>", "<Plug>(wildfire-quick-select)", {})