-- https://github.com/nvim-telescope/telescope.nvim

local telescope = require "telescope"
local telescope_themes = require "telescope.themes"
local telescope_builtin = require "telescope.builtin"
local actions = require "telescope.actions"
local Path = require "plenary.path"
local utils = require "fengwk.utils"

local function jdtls_exclude_prompt(prompt)
  -- 过滤掉空字符提升检索效率
  return prompt == ""
end

local function jdtls_sort_prompt_pre_process(prompt)
  -- jdtls中可能会使用*进行模糊匹配查询，这与最后fzf时的sort冲突，因此在进行fzf搜索前先将*过滤掉
  prompt = string.gsub(prompt, "*", "")
  return prompt
end

-- windows需要安装rg来支持grep
-- scoop install ripgrep
-- windows sqllite 支持
if utils.sys.os == "windows" then
  local sqllite_dll = vim.fs.joinpath(vim.fn.stdpath("config"), "lib", "sqllite", "sqlite3.dll")
  vim.g["sqlite_clib_path"] = sqllite_dll
end

telescope.setup {
  defaults = {
    history = { -- 支持telescope历史与cwd绑定
      path = vim.fs.joinpath(vim.fn.stdpath("data"), "telescope_history.sqlite3"),
      limit = 500,
    },
    winblend = vim.o.winblend, -- 提供窗口透明，使用全局的winblend
    -- Determines how file paths are displayed
    path_display = {
      -- tail = true,
      truncate = 1, -- 从前边进行截断，这通常符合预期，因为需要看到文件名称，1代表截断前的路径只展示一个字符
    },
    -- path_display = function(_, path)
    --   -- 处理path为相对路径
    --   local cwd = vim.fn.getcwd()
    --   if Path:new(cwd):is_dir() then
    --     path = Path:new(path):make_relative(cwd)
    --   end
    --
    --   local limit = 70
    --
    --   if string.len(path) < limit then
    --     return path
    --   end
    --
    --   -- shorten 简短路径只展示1个字符，第1、2、-1部分不缩短
    --   -- return Path:new(path):shorten(1, { 1, 2, -1 })
    --   -- return Path:new(path):shorten(1, { 1, -1 })
    --   path = Path:new(path):shorten(1, { 1, -1 })
    --   if string.len(path) < limit then
    --     return path
    --   end
    --
    --   return Path:new(path):shorten(1, { -1 })
    -- end,

    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ["<C-h>"] = "which_key"
        -- 回溯历史输入并进入了的内容
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        -- 上下移动
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        -- 转到搜索模式
        ["<C-f>"] = actions.to_fuzzy_refine,
        -- 上下移动preview
        -- <C-u>/<C-d>
        ["<C-c>"] = actions.close,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-Tab>"] = actions.toggle_all,
        ["<C-S-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
      n = {
        ["<C-c>"] = actions.close,
        ["q"] = actions.close,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-Tab>"] = actions.toggle_all,
        ["<C-S-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
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
      mappings = {
        n = {
          ["dd"] = "delete_buffer",
        }
      }
      -- previewer = false,
    },
    oldfiles = {
      theme = "dropdown",
      -- previewer = false,
    },
    filetypes = {
      theme = "dropdown",
    },
    colorscheme = {
      theme = "dropdown",
    },
    quickfixhistory = {
      theme = "dropdown",
    },
    help_tags = {
      theme = "dropdown",
    },
    git_commits = {
      theme = "dropdown",
    },
    git_branches = {
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
      telescope_themes.get_dropdown {},
    },

    ["workspace"] = {
      telescope_themes.get_dropdown {},
    },

    ["jdtls"] = {
      telescope_themes.get_dropdown {},
    },

    ["bookmarks"] = {
      telescope_themes.get_dropdown {},
    },

    ["diff"] = {
      telescope_themes.get_dropdown {},
    },

    ["live_grep_args"] = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- override default mappings
      -- default_mappings = {},
      mappings = { -- extend mappings
        i = {
          -- ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-k>"] = "move_selection_previous", -- 修改默认加引号行为
        }
      },
    },

    ["lsp_handlers"] = {
      location = {
        telescope = require('telescope.themes').get_dropdown({
          path_display = {
            truncate = 1,
          },
        }),
        telescope_jdtls = require('telescope.themes').get_dropdown({
          path_display = {
            tail = true,
          },
        }),
      },
      symbol = {
        telescope = require('telescope.themes').get_dropdown({}),
      },
      call_hierarchy = {
        telescope = require('telescope.themes').get_dropdown({
          path_display = {
            truncate = 1,
          },
        }),
      },
      code_action = {
        telescope = require('telescope.themes').get_dropdown({}),
      },
      dynamic_workspace_symbols = {
        telescope = require('telescope.themes').get_dropdown({
          path_display = {
            truncate = 1,
          },
          exclude_prompt = jdtls_exclude_prompt,
          sort_prompt_pre_process = jdtls_sort_prompt_pre_process,
        }),
      },
    },

    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },

    aerial = {
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = {
        ['_'] = false, -- This key will be the default
        json = true,   -- You can set the option for specific filetypes
        yaml = true,
      },
    },

  },
}

-- load_extension, somewhere after setup function:
telescope.load_extension("ui-select")
telescope.load_extension("workspace")
telescope.load_extension("live_grep_args")
telescope.load_extension("lsp_handlers")
telescope.load_extension("jdtls")
-- Token      Match type                    Description
-- sbtrkt     fuzzy-match                   Items that match sbtrkt
-- 'wild      exact-match (quoted)          Items that include wild
-- ^music     prefix-exact-match            Items that start with music
-- .mp3$      suffix-exact-match            Items that end with .mp3
-- !fire      inverse-exact-match           Items that do not include fire
-- !^music    inverse-prefix-exact-match    Items that do not start with music
-- !.mp3$     inverse-suffix-exact-match    Items that do not end with .mp3
telescope.load_extension("fzf")
-- telescope.load_extension("aerial")
-- telescope.load_extension("dap")
telescope.load_extension("diff")
telescope.load_extension("bookmarks")
telescope.load_extension("smart_history")

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
  -- telescope.extensions.live_grep_args.live_grep_args(telescope_themes.get_ivy())
  telescope.extensions.live_grep_args.live_grep_args(telescope_themes.get_dropdown())
  -- telescope_builtin.live_grep({
  --   -- {cwd}                 (string)        root dir to search from
  --   --                                       (default: cwd, use
  --   --                                       utils.buffer_dir() to search
  --   --                                       relative to open buffer)
  --   -- {grep_open_files}     (boolean)       if true, restrict search to open
  --   --                                       files only, mutually exclusive
  --   --                                       with `search_dirs`
  --   -- {search_dirs}         (table)         directory/directories/files to
  --   --                                       search, mutually exclusive with
  --   --                                       `grep_open_files`
  --   -- {glob_pattern}        (string|table)  argument to be used with
  --   --                                       `--glob`, e.g. "*.toml", can use
  --   --                                       the opposite "!*.toml"
  --   -- {type_filter}         (string)        argument to be used with
  --   --                                       `--type`, e.g. "rust", see `rg
  --   --                                       --type-list`
  --   -- {additional_args}     (function)      function(opts) which returns a
  --   --                                       table of additional arguments to
  --   --                                       be passed on
  --   -- {max_results}         (number)        define a upper result value
  --   -- {disable_coordinates} (boolean)       don't show the line & row
  -- })
end

-- :h telescope.builtin.oldfiles()
local function telescope_builtin_oldfiles()
  telescope_builtin.oldfiles({
    -- {only_cwd} (boolean)  show only files in the cwd (default: false)
    -- {cwd_only} (boolean)  alias for only_cwd
  })
end

local keymap = vim.keymap
keymap.set("n", "<leader>fb", function() telescope_builtin_buffers(false) end, { desc = "Telescope Buffers" })
keymap.set("n", "<leader>fB", function() telescope_builtin_buffers(true) end, { noremap = true, silent = true, desc = "Telescope Buffers (Show All)" })
keymap.set("n", "<leader>ff", function() telescope_builtin_find_files(false) end, { desc = "Telescope Find Files" })
keymap.set("n", "<leader>fF", function() telescope_builtin_find_files(true) end, { desc = "Telescope Find Files (Show All)" })
keymap.set("n", "<leader>fg", telescope_builtin_live_grep_args, { desc = "Telescope Live Grep" })
keymap.set("n", "<leader>fo", telescope_builtin_oldfiles, { desc = "Telescope Oldfiles" })
keymap.set("n", "<leader>fh", function() telescope_builtin.help_tags() end, { desc = "Telescope Help Tags" })
keymap.set("n", "<leader>ft", function() telescope_builtin.filetypes() end, { desc = "Telescope Filetypes" })
keymap.set("n", "<leader>fs", "<Cmd>Telescope workspace workspaces<CR>", { silent = true, desc = "Open Workspaces" })
keymap.set("n", "<leader>ma", "<Cmd>Telescope bookmarks bookmarks<CR>", { silent = true, desc = "Open Workspaces" })
vim.api.nvim_create_user_command("DiffFile", function () telescope.extensions.diff.diff_file() end, {})
-- vim.keymap.set("n", "<leader>fq", "<Cmd>Telescope quickfixhistory<CR>", { noremap = true, silent = true, desc = "Load Workspaces" })
-- keymap.set("n", "<leader>fc", function() telescope_builtin.colorscheme() end, { desc = "Telescope Colorscheme" })
-- vim.api.nvim_create_user_command("GitCommits", function() telescope_builtin.git_commits() end, {})
-- vim.api.nvim_create_user_command("GitBranchs", function() telescope_builtin.git_branches() end, {})

-- vim.keymap.set("n", "<leader>fdb", "<Cmd>Telescope dap list_breakpoints theme=dropdown<CR>", { noremap = true, silent = true, desc = "Telescope Breakpoints" })
-- vim.keymap.set("n", "<leader>fdv", "<Cmd>Telescope dap variables theme=dropdown<CR>", { noremap = true, silent = true, desc = "Telescope Variables" })
-- vim.keymap.set("n", "<leader>fdf", "<Cmd>Telescope dap frames theme=dropdown<CR>", { noremap = true, silent = true, desc = "Telescope Frames" })
-- vim.keymap.set("n", "<leader>fdc", "<Cmd>Telescope dap commands theme=dropdown<CR>", { noremap = true, silent = true, desc = "Telescope Commands" })
-- vim.keymap.set("n", "<leader>fdC", "<Cmd>Telescope dap configurations theme=dropdown<CR>", { noremap = true, silent = true, desc = "Telescope Configuration" })
