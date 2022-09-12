-- https://github.com/nvim-telescope/telescope.nvim

-- Mappings     Action
-- <C-n>/<Down> Next item
-- <C-p>/<Up>   Previous item
-- j/k          Next/previous (in normal mode)
-- H/M/L        Select High/Middle/Low (in normal mode)
-- gg/G         Select the first/last item (in normal mode)
-- <CR>         Confirm selection
-- <C-x>        Go to file selection as a split
-- <C-v>        Go to file selection as a vsplit
-- <C-t>        Go to a file in a new tab
-- <C-u>        Scroll up in preview window
-- <C-d>        Scroll down in preview window
-- <C-/>        Show mappings for picker actions (insert mode)
-- ?            Show mappings for picker actions (normal mode)
-- <C-c>        Close telescope
-- <Esc>        Close telescope (in normal mode)
-- <Tab>        Toggle selection and move to next selection
-- <S-Tab>      Toggle selection and move to prev selection
-- <C-q>        Send all items not filtered to quickfixlist (qflist)
-- <M-q>        Send all selected items to qflist

require("telescope").setup {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ["<C-h>"] = "which_key"
        -- 回溯历史输入并进入了的内容
        ["<C-n>"] = "cycle_history_next",
        ["<C-p>"] = "cycle_history_prev",
        -- 上下移动
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        -- esc直接关闭
        -- ["<Esc>"] = "close",
      },
      n = {
        ["<C-c>"] = "close",
      },
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
    live_grep = {
      theme = "ivy",
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
    },
    oldfiles = {
      theme = "dropdown",
      previewer = false,
    },
    lsp_references = {
      theme = "ivy",
    },
    lsp_incoming_calls = {
      theme = "ivy",
    },
    lsp_outgoing_calls = {
      theme = "ivy",
    },
    lsp_document_symbols = {
      theme = "ivy",
    },
    lsp_workspace_symbols = {
      theme = "ivy",
    },
    lsp_dynamic_workspace_symbols = {
      theme = "ivy",
    },
    diagnostics = {
      theme = "ivy",
    },
    lsp_implementations = {
      theme = "ivy",
    },
    lsp_definitions = {
      theme = "ivy",
    },
    lsp_type_definitions = {
      theme = "ivy",
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }
}

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")

-- :h telescope.builtin.buffers()
local function telescope_builtin_buffers(show_all)
  require("telescope.builtin").buffers({
    -- {show_all_buffers}      (boolean)  if true, show all buffers,
    --                                    including unloaded buffers
    --                                    (default: true)
    -- {ignore_current_buffer} (boolean)  if true, don't show the current
    --                                    buffer in the list (default: false)
    -- {only_cwd}              (boolean)  if true, only show buffers in the
    --                                    current working directory (default:
    --                                    false)
    -- {cwd_only}              (boolean)  alias for only_cwd
    -- {sort_lastused}         (boolean)  Sorts current and last buffer to
    --                                    the top and selects the lastused
    --                                    (default: false)
    -- {sort_mru}              (boolean)  Sorts all buffers after most recent
    --                                    used. Not just the current and last
    --                                    one (default: false)
    -- {bufnr_width}           (number)   Defines the width of the buffer
    --                                    numbers in front of the filenames 
    --                                    (default: dynamic)
    ignore_current_buffer = not show_all,
    sort_mru = true,
  })
end

-- :h telescope.builtin.find_files()
local function telescope_builtin_find_files(show_all)
  require("telescope.builtin").find_files({
    -- {cwd}              (string)          root dir to search from (default:
    --                                      cwd, use utils.buffer_dir() to
    --                                      search relative to open buffer)
    -- {find_command}     (function|table)  cmd to use for the search. Can be
    --                                      a fn(opts) -> tbl (default:
    --                                      autodetect)
    -- {follow}           (boolean)         if true, follows symlinks (i.e.
    --                                      uses `-L` flag for the `find`
    --                                      command)
    -- {hidden}           (boolean)         determines whether to show hidden
    --                                      files or not (default: false)
    -- {no_ignore}        (boolean)         show files ignored by .gitignore,
    --                                      .ignore, etc. (default: false)
    -- {no_ignore_parent} (boolean)         show files ignored by .gitignore,
    --                                      .ignore, etc. in parent dirs.
    --                                      (default: false)
    -- {search_dirs}      (table)           directory/directories/files to
    --                                      search
    -- {search_file}      (string)          specify a filename to search for
    hidden = show_all,
    no_ignore = show_all,
    no_ignore_parent = show_all,
  })
end

-- :h telescope.builtin.live_grep()
local function telescope_builtin_live_grep()
  require("telescope.builtin").live_grep({
    -- {cwd}                 (string)        root dir to search from
    --                                       (default: cwd, use
    --                                       utils.buffer_dir() to search
    --                                       relative to open buffer)
    -- {grep_open_files}     (boolean)       if true, restrict search to open
    --                                       files only, mutually exclusive
    --                                       with `search_dirs`
    -- {search_dirs}         (table)         directory/directories/files to
    --                                       search, mutually exclusive with
    --                                       `grep_open_files`
    -- {glob_pattern}        (string|table)  argument to be used with
    --                                       `--glob`, e.g. "*.toml", can use
    --                                       the opposite "!*.toml"
    -- {type_filter}         (string)        argument to be used with
    --                                       `--type`, e.g. "rust", see `rg
    --                                       --type-list`
    -- {additional_args}     (function)      function(opts) which returns a
    --                                       table of additional arguments to
    --                                       be passed on
    -- {max_results}         (number)        define a upper result value
    -- {disable_coordinates} (boolean)       don't show the line & row
  })
end

-- :h telescope.builtin.oldfiles()
local function telescope_builtin_oldfiles()
  require("telescope.builtin").oldfiles({
    -- {only_cwd} (boolean)  show only files in the cwd (default: false)
    -- {cwd_only} (boolean)  alias for only_cwd
  })
end

vim.keymap.set("n", "<leader>fb", function() telescope_builtin_buffers(false) end, { noremap = true, silent = true, desc = "Telescope Buffers" })
vim.keymap.set("n", "<leader>fB", function() telescope_builtin_buffers(true) end, { noremap = true, silent = true, desc = "Telescope Buffers (Show All)" })
vim.keymap.set("n", "<leader>ff", function() telescope_builtin_find_files(false) end, { noremap = true, silent = true, desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>fF", function() telescope_builtin_find_files(true) end, { noremap = true, silent = true, desc = "Telescope Find Files (Show All)" })
vim.keymap.set("n", "<leader>fg", telescope_builtin_live_grep, { noremap = true, silent = true, desc = "Telescope Live Grep" })
vim.keymap.set("n", "<leader>fo", telescope_builtin_oldfiles, { noremap = true, silent = true, desc = "Telescope Oldfiles" })
-- :h telescope.builtin.help_tags()
-- vim.keymap.set("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap = true, silent = true, desc = "Telescope Help Tags" })