local utils = require("user.utils")
local enhancer = require("user.conf.workspaces.enhancer")

local ws_dir = utils.fs_concat({ vim.fn.stdpath("cache"), "workspaces" })
utils.ensure_mkdir(ws_dir)

require("workspaces").setup({
    -- on a unix system this would be ~/.local/share/nvim/workspaces
    path = utils.fs_concat({ ws_dir, "ws" }),

    -- to change directory for all of nvim (:cd) or only for the current window (:lcd)
    -- if you are unsure, you likely want this to be true.
    global_cd = true,

    -- sort the list of workspaces by name after loading from the workspaces path.
    sort = true,

    -- sort by recent use rather than by name. requires sort to be true
    mru_sort = true,

    -- enable info-level notifications after adding or removing a workspace
    notify_info = true,

    -- lists of hooks to run after specific actions
    -- hooks can be a lua function or a vim command (string)
    -- lua hooks take a name, a path, and an optional state table
    -- if only one hook is needed, the list may be omitted
    hooks = {
        add = {
          "lua require('user.conf.workspaces.enhancer').record_ws_buf('" ..  ws_dir .."')",
        },
        remove = {},
        rename = {},
        open_pre = {},
        open = {
          -- "Telescope find_files",
          "lua require('user.conf.workspaces.enhancer').reload_ws_buf('" ..  ws_dir .."')",
        },
    },
})

vim.keymap.set("n", "<leader>fs", "<Cmd>Telescope workspaces theme=dropdown<CR>", { noremap = true, silent = true, desc = "Load Workspaces" })

vim.api.nvim_create_augroup("user_workspaces", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = "user_workspaces",
  pattern = "*",
  callback = function()
    enhancer.auto_load_ws(ws_dir)
  end
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = "user_workspaces",
  pattern = "*",
  callback = function()
    enhancer.record_ws_buf(ws_dir)
  end
})