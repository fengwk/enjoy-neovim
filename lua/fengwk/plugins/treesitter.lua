-- https://github.com/nvim-treesitter/nvim-treesitter

local ok, nvim_treesitter_config = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

local utils = require("fengwk.utils")

local enable_fts = {
  "ada",
  "agda",
  "arduino",
  "astro",
  "bash",
  "beancount",
  "bibtex",
  "blueprint",
  "c",
  "c_sharp",
  "capnp",
  "chatito",
  "clojure",
  "cmake",
  "comment",
  "commonlisp",
  "cooklang",
  "cpp",
  "css",
  "cuda",
  "d",
  "dart",
  "devicetree",
  "diff",
  "dockerfile",
  "dot",
  "ebnf",
  "eex",
  "elixir",
  "elm",
  "elsa",
  "elvish",
  "erlang",
  "fennel",
  "fish",
  "foam",
  "fsh",
  "func",
  "fusion",
  "Godot",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "gleam",
  "GlimmerandEmber",
  "glsl",
  "go",
  "GodotResources",
  "gomod",
  "gosum",
  "gowork",
  "graphql",
  "hcl",
  "heex",
  "help",
  "hjson",
  "hlsl",
  "hocon",
  "html",
  "htmldjango",
  "http",
  "ini",
  "java",
  "javascript",
  "jq",
  "jsdoc",
  -- "json", -- 避免大json导致卡死
  "json5",
  "JSONwithcomments",
  "jsonnet",
  "julia",
  "kdl",
  "kotlin",
  "lalrpop",
  "latex",
  "ledger",
  "llvm",
  "lua",
  "m68k",
  "make",
  "markdown",
  "markdown_inline",
  "menhir",
  "mermaid",
  "meson",
  "ninja",
  "nix",
  "norg",
  "ocaml",
  "ocaml_interface",
  "ocamllex",
  "pascal",
  "perl",
  "php",
  "phpdoc",
  "pioasm",
  "PathofExileitemfilter",
  "prisma",
  "proto",
  "pug",
  "python",
  "ql",
  "qmljs",
  "Tree-sitterquerylanguage",
  "r",
  "racket",
  "rasi",
  "regex",
  "rego",
  "rnoweb",
  "ron",
  "rst",
  "ruby",
  "rust",
  "scala",
  "scheme",
  "scss",
  "slint",
  "smali",
  "smithy",
  "solidity",
  "sparql",
  "sql",
  "supercollider",
  "surface",
  "svelte",
  "swift",
  "sxhkdrc",
  "t32",
  "teal",
  "terraform",
  "thrift",
  "tiger",
  "tlaplus",
  "todotxt",
  "toml",
  "tsx",
  "turtle",
  "twig",
  "typescript",
  "v",
  "vala",
  "verilog",
  "vhs",
  "vim",
  "vue",
  "wgsl",
  "wgsl_bevy",
  "yaml",
  "yang",
  "zig",
}

local function disable_ts(lang, buf)
  -- 如果不在支持的ft列表中则直接禁用
  if not vim.tbl_contains(enable_fts, lang) then
    return true
  end
  -- 如果是缓冲区过大则禁用
  return utils.is_large_buffer(buf)
end

-- 自动切换折叠模式
vim.api.nvim_create_augroup("user_treesitter_fold", { clear = true })
vim.api.nvim_create_autocmd(
  { "Filetype" },
  { group = "user_treesitter_fold", pattern = "*", callback = function()
    local ft = vim.fn.expand("<amatch>")
    if disable_ts(ft, 0) then
      vim.o.foldmethod = "indent"
    else
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
      vim.o.foldenable = false
    end
  end}
)

nvim_treesitter_config.setup({
  ensure_installed = "all", -- 自动安装清单，可以使用"all"安装所有解析器
  sync_install = false, -- 是否同步安装
  auto_install = true, -- 进入缓冲区时自动安装

  highlight = {
    enable = true, -- 是否开启高亮

    -- 这个函数可以定义什么情况下关闭高亮，返回true时将关闭高亮
    disable = disable_ts,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  -- 增量选择语法树区间
  incremental_selection = {
    enable = true,
    keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
			scope_incremental = "<leader><CR>",
			node_decremental = "<BS>",
		},
  },

})