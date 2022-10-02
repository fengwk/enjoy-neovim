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

local telescope = require "telescope"
local telescope_themes = require "telescope.themes"
local telescope_builtin = require "telescope.builtin"

telescope.setup {
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
      -- previewer = false,
    },
    live_grep = {
      theme = "dropdown",
    },
    buffers = {
      theme = "dropdown",
      -- previewer = false,
    },
    oldfiles = {
      theme = "dropdown",
      -- previewer = false,
    },
    help_tags = {
      theme = "dropdown",
    },
    lsp_references = {
      theme = "dropdown",
    },
    lsp_incoming_calls = {
      theme = "dropdown",
    },
    lsp_outgoing_calls = {
      theme = "dropdown",
    },
    lsp_document_symbols = {
      theme = "dropdown",
    },
    lsp_workspace_symbols = {
      theme = "dropdown",
    },
    lsp_dynamic_workspace_symbols = {
      theme = "dropdown",
    },
    diagnostics = {
      theme = "dropdown",
    },
    lsp_implementations = {
      theme = "dropdown",
    },
    lsp_definitions = {
      theme = "dropdown",
    },
    lsp_type_definitions = {
      theme = "dropdown",
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    ["ui-select"] = {
      telescope_themes.get_dropdown {
        -- even more opts
      },
    },

    -- ["live_grep_args"] = {
    --   auto_quoting = true, -- enable/disable auto-quoting
    --   -- override default mappings
    --   -- default_mappings = {},
    --   mappings = { -- extend mappings
    --     i = {
    --       -- ["<C-k>"] = lga_actions.quote_prompt(),
    --       ["<C-k>"] = "move_selection_previous", -- 修改默认加引号行为
    --     }
    --   },
    -- },

    ["lsp_handlers"] = {
      location = {
        telescope = require('telescope.themes').get_dropdown({}),
      },
      symbol = {
        telescope = require('telescope.themes').get_dropdown({}),
      },
      call_hierarchy = {
        telescope = require('telescope.themes').get_dropdown({}),
      },
      code_action = {
        telescope = require('telescope.themes').get_dropdown({}),
      },
    },

    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
  },
}

-- load_extension, somewhere after setup function:
telescope.load_extension("ui-select")
-- telescope.load_extension("live_grep_args")
telescope.load_extension('lsp_handlers')
-- Token      Match type                    Description
-- sbtrkt     fuzzy-match                   Items that match sbtrkt
-- 'wild      exact-match (quoted)          Items that include wild
-- ^music     prefix-exact-match            Items that start with music
-- .mp3$      suffix-exact-match            Items that end with .mp3
-- !fire      inverse-exact-match           Items that do not include fire
-- !^music    inverse-prefix-exact-match    Items that do not start with music
-- !.mp3$     inverse-suffix-exact-match    Items that do not end with .mp3
telescope.load_extension('fzf')

-- :h telescope.builtin.buffers()
local function telescope_builtin_buffers(show_all)
  telescope_builtin.buffers({
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
  telescope_builtin.find_files({
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
local function telescope_builtin_live_grep_args()
  -- https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
  -- -i ignore case
  -- -s 大小写敏感
  -- -w match word
  -- -e 正则表达式匹配
  -- -v 反转匹配
  -- -g 通配符文件或文件夹，可以用!来取反
  -- -F fixed-string 原意字符串，类似python的 r'xxx'
  -- 例如使用`-g **/lsp/* require`查找lsp目录下所有require字符
  -- telescope.extensions.live_grep_args.live_grep_args(telescope_themes.get_dropdown())
  telescope_builtin.live_grep({
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
  telescope_builtin.oldfiles({
    -- {only_cwd} (boolean)  show only files in the cwd (default: false)
    -- {cwd_only} (boolean)  alias for only_cwd
  })
end

-- :h telescope.builtin.help_tags()
local function telescope_builtin_help_tags()
  telescope_builtin.help_tags()
end

vim.keymap.set("n", "<leader>fb", function() telescope_builtin_buffers(false) end, { noremap = true, silent = true, desc = "Telescope Buffers" })
vim.keymap.set("n", "<leader>fB", function() telescope_builtin_buffers(true) end, { noremap = true, silent = true, desc = "Telescope Buffers (Show All)" })
vim.keymap.set("n", "<leader>ff", function() telescope_builtin_find_files(false) end, { noremap = true, silent = true, desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>fF", function() telescope_builtin_find_files(true) end, { noremap = true, silent = true, desc = "Telescope Find Files (Show All)" })
vim.keymap.set("n", "<leader>fg", telescope_builtin_live_grep_args, { noremap = true, silent = true, desc = "Telescope Live Grep" })
vim.keymap.set("n", "<leader>fo", telescope_builtin_oldfiles, { noremap = true, silent = true, desc = "Telescope Oldfiles" })
vim.keymap.set("n", "<leader>fh", telescope_builtin_help_tags, { noremap = true, silent = true, desc = "Telescope Help Tags" })