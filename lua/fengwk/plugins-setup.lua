-- 自动安装packer
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer()

-- 保存当前文件时自动执行PackerSync命令
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- packer - https://github.com/wbthomason/packer.nvim
-- awesome-neovim - https://github.com/rockerBOO/awesome-neovim
local ok, packer = pcall(require, "packer")
if not ok then
	return
end

-- 自定义初始化
packer.init({
	clone_timeout = 60 * 10, -- git clone超时，秒
  display = {
    prompt_border = "rounded",
  }
})

return packer.startup(function(use)

	-- mixed
  use "wbthomason/packer.nvim" -- 管理packer自身
  -- use { "syscall0x80/vimdoccn", ft = "help" } -- 中文版vimdoc
  use "fengwk/im-switch.nvim" -- 中英文切换
  use "voldikss/vim-translator" -- 翻译
  use "stevearc/stickybuf.nvim" -- 锁定buffer，避免误操作在非预期的位置打开窗口，比如在qf里打开了窗口
  use "jghauser/mkdir.nvim" -- 保存文件时自动创建不存在的目录
  -- use "karb94/neoscroll.nvim" -- 支持平滑滚动
  use "stevearc/dressing.nvim"

  -- themes
  use "catppuccin/nvim"
  use "ellisonleao/gruvbox.nvim"
  use "rebelot/kanagawa.nvim"
  use "Mofiqul/vscode.nvim"
  use "sainnhe/everforest"
  use "projekt0n/github-nvim-theme"
  use "kdheepak/monochrome.nvim"
  use "bluz71/vim-nightfly-colors"
  -- use "fengwk/my-darkplus.nvim"

	-- file explorer
  use { "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" }

  -- terminal
  use { "akinsho/toggleterm.nvim", tag = "*" }

  -- git
  use "lewis6991/gitsigns.nvim"
  -- use "sindrets/diffview.nvim"

  -- markdown
  use { "iamcco/markdown-preview.nvim", run = "cd app && yarn install", ft = "markdown" } -- 在浏览器中预览Markdown
  use { "md-img-paste-devs/md-img-paste.vim", ft = "markdown" } -- 黏贴剪切板中的图片到Markdown

  -- workspaces
  use "natecraddock/workspaces.nvim" -- 简单的工作空间管理
  use "fengwk/workspaces-enhancer.nvim" -- workspaces.nvim功能增强set

	-- editor enhancer
	use "kylechui/nvim-surround" -- surround
  use "gbprod/substitute.nvim" -- 替换{motion}
	use "numToStr/Comment.nvim" -- 注释
	use "mg979/vim-visual-multi" -- 多光标，:h vm-*
  use "kevinhwang91/nvim-bqf" -- quickfix增强
  use { "phaazon/hop.nvim", branch = "v2" } -- like easymotion
  -- use { "fengwk/wildfire.vim", branch = "feat/skip-same-size-textobj" } -- textobjects选择器，使用tree-sitter替代
  use "windwp/nvim-autopairs" -- 自动补充成对符号
  use "godlygeek/tabular" -- 自定义对齐格式化
  use "jbyuki/venn.nvim" -- 绘制ASCII图
  -- use("kana/vim-textobj-user") -- 支持用户自定义textobj

	-- ui enhancer
  use { "nvim-lualine/lualine.nvim", requires = "kyazdani42/nvim-web-devicons" } -- 状态栏增强
  use "NvChad/nvim-colorizer.lua" -- 颜色提示
  use "lukas-reineke/indent-blankline.nvim" -- 垂直缩进线

	-- autocompletion
	-- use "hrsh7th/nvim-cmp" -- 自动补全插件
	use { "fengwk/nvim-cmp", branch = "fix/huge-single-line-performance" }
	use "hrsh7th/cmp-buffer" -- 缓冲区补全源
	use "hrsh7th/cmp-path" -- 文件系统路径补全源
  -- use "hrsh7th/cmp-cmdline" -- 命令行路径补全源
	use "hrsh7th/cmp-nvim-lsp" -- lsp补全源
  use "rcarriga/cmp-dap" -- nvim-cmp source for nvim-dap REPL and nvim-dap-ui buffers
	-- snippets
	use "hrsh7th/cmp-vsnip" -- 将vim-vsnip桥接到nvim-cmp上
	use "hrsh7th/vim-vsnip" -- vscode规范的snippets补全
	-- use "rafamadriz/friendly-snippets" -- 现成的snippets

	-- fuzzy finding
  use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" }, tag = "0.1.1" } -- 模糊搜索插件
  -- use "nvim-telescope/telescope-ui-select.nvim" -- ui.select与telescope集成 
  use "nvim-telescope/telescope-live-grep-args.nvim" -- live grep增强
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" } -- 模糊搜索增强
  -- use "nvim-telescope/telescope-dap.nvim"
  use "tom-anders/telescope-vim-bookmarks.nvim"
  use "MattesGroeger/vim-bookmarks"

  -- use "folke/which-key.nvim" -- 快捷键管理与提示

	-- managing & installing lsp servers, linters & formatters
	use "williamboman/mason.nvim"

  -- lsp
	use "williamboman/mason-lspconfig.nvim"
	use "neovim/nvim-lspconfig" -- lsp配置
	use "onsails/lspkind.nvim" -- lsp补全源美化
	-- use "glepnir/lspsaga.nvim" -- lsp ui增强
  -- use "https://git.sr.ht/~whynothugo/lsp_lines.nvim" -- 提供多行lsp提示信息展示能力，目前看这个插件会导致性能下降
	use "stevearc/aerial.nvim" -- outline
  use "RRethy/vim-illuminate" -- 代码符号高亮，并支持在符号之间跳跃
	-- use "jose-elias-alvarez/typescript.nvim" -- ts lsp增强
	-- use "mfussenegger/nvim-jdtls" -- java lsp增强
  use {"fengwk/nvim-jdtls", branch = "fix/altbuf"}

	-- formatting & linting
	-- use "jayp0521/mason-null-ls.nvim" -- bridges gap b/w mason & null-lssetu
	-- use "jose-elias-alvarez/null-ls.nvim" -- configure formatters & linters
	use "gpanders/editorconfig.nvim" -- editorconfig规范实现

	-- dap | Debug Adapter Protocol
	use "jayp0521/mason-nvim-dap.nvim"
	use "mfussenegger/nvim-dap"
	use "theHamsta/nvim-dap-virtual-text"
	use "rcarriga/nvim-dap-ui" -- 现有问题：让java应用debug变得很慢

  -- nvim-treesitter | 提供代码的语法解析和高亮，比neovim原生的解析器更快且更加强大
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  }
  -- nvim-treesitter-textobjects | 使用treesitter增强textobjets
  use "nvim-treesitter/nvim-treesitter-textobjects"

  -- chatgpt
  use "MunifTanjim/nui.nvim"
  -- use "jackMort/ChatGPT.nvim"
  use { "fengwk/ChatGPT.nvim", branch = "dev" }


  -- libs
  use_rocks { "utf8" }
  require("packer.luarocks").setup_paths()

	if packer_bootstrap then
		require("packer").sync()
	end

end)
