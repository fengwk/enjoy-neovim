-- packer: neovim package manager
-- https://github.com/wbthomason/packer.nvim
-- :h packer.txt
-- :h packer-commands

-- awesome-neovim: neovim plugins colletions
-- https://github.com/rockerBOO/awesome-neovim

-- use usage
-- use {
--   "myusername/example",        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   bufread = boolean,           -- Manually specifying if a plugin needs BufRead after being loaded
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use. Supports "*" for "latest tag"
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When requiring a string which matches one of these patterns, the plugin will be loaded.
-- }

-- use_rocks: install lua lib

local packer = require "packer"

return packer.startup(function(use)

  -- packer can manage itself
  use "wbthomason/packer.nvim"

  -- 中文版vimdoc
  use "syscall0x80/vimdoccn"

  -- doom-one.nvim
  -- use "NTBBloodbath/doom-one.nvim"
  -- github-nvim-theme
  -- use "projekt0n/github-nvim-theme"
  -- catppuccin
  -- use { "catppuccin/nvim", as = "catppuccin" }
  -- themer
  -- use "themercorp/themer.lua"
  -- darkplus
  -- use "fengwk/darkplus.nvim"

  -- nvim-colorizer
  use {
    "norcalli/nvim-colorizer.lua",
    config = function() require
      "user.conf.nvim-colorizer"
    end,
  }

  -- statusline，已集成了lsp-status
  use {
    "beauwilliams/statusline.lua",
    config = function ()
      require "user.conf.statusline"
    end
  }
  -- lualine
  -- use {
  --   "nvim-lualine/lualine.nvim",
  --   requires = { "kyazdani42/nvim-web-devicons", opt = true },
  --   config = function()
  --     require "user.conf.lualine"
  --   end
  -- }

  -- nvim-bqf
  use {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  }
  -- use {
  --   "junegunn/fzf",
  --   run = function()
  --       vim.fn['fzf#install']()
  --   end
  -- }

  -- nvim-tree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require "user.conf.nvim-tree"
    end,
  }
  -- use {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "v2.x",
  --   requires = {
  --     "nvim-lua/plenary.nvim",
  --     "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
  --     "MunifTanjim/nui.nvim",
  --     {
  --       -- only needed if you want to use the commands with "_with_window_picker" suffix
  --       "s1n7ax/nvim-window-picker",
  --       tag = "v1.*",
  --       config = function()
  --         require "user.conf.nvim-window-picker"
  --       end,
  --     }
  --   },
  --   config = function()
  --     require "user.conf.neo-tree"
  --   end
  -- }

  -- bufferline
  -- use {
  --   "akinsho/bufferline.nvim",
  --   requires = "kyazdani42/nvim-web-devicons",
  --   tag = "v2.*",
  --   config = function()
  --     require "user.conf.bufferline"
  --   end,
  -- }

  -- toggleterm
  use {
    "akinsho/toggleterm.nvim",
    tag = "v2.*",
    config = function()
      require "user.conf.terminal"
    end,
  }

  -- Comment
  use {
    "numToStr/Comment.nvim",
    config = function()
      require "user.conf.comment"
    end,
  }

  -- nvim-cmp
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require "user.conf.nvim-cmp"
    end,
  }
  use "hrsh7th/cmp-nvim-lsp"         -- lsp补全源
  use "hrsh7th/cmp-buffer"           -- 缓冲区补全源
  use "hrsh7th/cmp-path"             -- 文件系统路径补全源
  use "hrsh7th/cmp-cmdline"          -- 命令行路径补全源
  use "hrsh7th/cmp-vsnip"            -- 将vim-vsnip桥接到nvim-cmp上
  use {                              -- vscode规范的snippets补全
    "hrsh7th/vim-vsnip",
    config = function()
      require "user.conf.vim-vsnip"
    end,
  }
  use "rafamadriz/friendly-snippets" -- 现成的snippets
  use "onsails/lspkind.nvim"         -- 美化支持

  -- nvim-autopairs
  use {
    "windwp/nvim-autopairs",
    config = function()
      require "user.conf.nvim-autopairs"
    end,
  }

  -- hop, like easymotion
  use {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    config = function()
      require "user.conf.hop"
    end,
  }

  -- nvim-surround
  use {
    "kylechui/nvim-surround",
    config = function()
      require "user.conf.nvim-surround"
    end,
  }

  -- vim-visual-multi
  use "mg979/vim-visual-multi"


  -- tabular
  use "godlygeek/tabular"

  -- veen.nvim
  -- use to draw ASCII graph
  use {
    "jbyuki/venn.nvim",
    config = function()
      require "user.conf.venn"
    end,
  }

  -- editorconfig
  use "gpanders/editorconfig.nvim"

  -- neovim-session-manager
  use {
    "Shatur/neovim-session-manager",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require "user.conf.neovim-session-manager"
    end
  }
  -- use {
  --   "olimorris/persisted.nvim",
  --   config = function()
  --     require "user.conf.persisted"
  --   end
  -- }

  -- telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    tag = "0.1.0",
    config = function()
      require "user.conf.telescope"
    end,
  }

  -- gitsigns
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require "user.conf.gitsigns"
    end,
  }

  -- which-key
  use({
    "folke/which-key.nvim",
    config = function()
      require "user.conf.which-key"
    end,
  })

  -- markdown-preview
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = "markdown",
    config = function()
      require "user.conf.markdown-preview"
    end
  }
  -- md-img-paste
  use {
    "md-img-paste-devs/md-img-paste.vim",
    ft = "markdown",
    config = function()
      require "user.conf.md-img-paste"
    end
  }

  -- translator
  use {
    "voldikss/vim-translator",
    config = function()
      require "user.conf.translator"
    end
  }

  -- nvim-treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require "user.conf.treesitter"
    end
  }

  -- mason：lsp包管理软件
  use "williamboman/mason.nvim"
  -- mason-lspconfig
  use "williamboman/mason-lspconfig.nvim"
  -- nvim-lspconfig
  use "neovim/nvim-lspconfig"
  -- nvim-jdtls
  use "mfussenegger/nvim-jdtls"
  -- nvim-dap
  use "mfussenegger/nvim-dap"
  use "theHamsta/nvim-dap-virtual-text"
  use "rcarriga/nvim-dap-ui"

  -- lsp-status
  use "nvim-lua/lsp-status.nvim"

  -- vim-illuminate
  use {
    "RRethy/vim-illuminate",
    config = function()
      require "user.conf.vim-illuminate"
    end,
  }

  -- lib
  use_rocks "luafilesystem"

end)