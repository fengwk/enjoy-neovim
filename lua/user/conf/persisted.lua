-- https://github.com/olimorris/persisted.nvim

-- :SessionToggle - Determines whether to load, start or stop a session
-- :SessionStart - Start recording a session. Useful if autosave = false
-- :SessionStop - Stop recording a session
-- :SessionSave - Save the current session
-- :SessionLoad - Load the session for the current directory and current branch if git_use_branch = true
-- :SessionLoadLast - Load the last session
-- :SessionDelete - Delete the current session

local persisted = require "persisted"
local telescope = require "telescope"

persisted.setup({
  save_dir = vim.fn.expand(vim.fn.stdpath("cache") .. "/persisted/"), -- directory where session files are saved
  command = "VimLeavePre", -- the autocommand for which the session is saved
  use_git_branch = false, -- create session files based on the branch of the git enabled repository
  branch_separator = "_", -- string used to separate session directory name from branch name
  autosave = true, -- automatically save session files when exiting Neovim
  autoload = true, -- automatically load the session for the cwd on Neovim startup
  on_autoload_no_session = function() -- function to run when `autoload = true` but there is no session to load
    vim.notify("No existing session to load.")
  end,
  -- allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
  -- 必须使用绝对路径
  allowed_dirs = { -- table of dirs that the plugin will auto-save and auto-load from
    -- vim.fn.expand("~/.config/dotfiles"),
    -- vim.fn.expand("~/prog"),
    -- vim.fn.expand("~/proj"),
    -- vim.fn.expand("~/go"),
    -- vim.fn.expand("~/Documents/work"),
    "/home/fengwk/.config/dotfiles",
    "/home/fengwk/prog",
    "/home/fengwk/proj",
    "/home/fengwk/go",
    "/home/fengwk/windows/e/Documents/work",
  },
  ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
  before_save = nil, -- function to run before the session is saved to disk
  after_save = nil, -- function to run after the session is saved to disk
  after_source = nil, -- function to run after the session is sourced
  telescope = { -- options for the telescope extension
    before_source = function() -- function to run before the session is sourced via telescope
      -- Close all open buffers
      -- Thanks to https://github.com/avently
      -- vim.api.nvim_input("<ESC>:%bd<CR>")
    end,
    after_source = function(session) -- function to run after the session is sourced via telescope
      vim.notify("Loaded session " .. session.name)
    end,
  },
})

telescope.load_extension("persisted") -- To load the telescope extension
vim.keymap.set("n", "<leader>fs", "<Cmd>Telescope persisted theme=dropdown<CR>", { noremap = true, silent = true, desc = "Telescope Persisted" })