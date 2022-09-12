-- https://github.com/catppuccin/nvim#integrations

local utils = require "user.utils"
require("catppuccin").setup({
  -- 是否透明
  transparent_background = false,
  -- 是否为终端渲染颜色
  term_colors = true,
  -- catppuccin可以通过预编译提升性能
  -- :CatppuccinCompile 编译
  -- :CatppuccinClean   清理编译文件
  -- :CatppuccinStatus  查看编译状态
  compile = {
    enabled = true,
    path = utils.fs_concat({ vim.fn.stdpath("cache"), "catppuccin" }),
  },
  -- 变暗不活跃的窗口
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.1,
  },
  -- 不同区域的风格，选项见:h highlight-args
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  -- catppuccin提供了一些插件的美化支持
  integrations = {
    -- For various plugins integrations see https://github.com/catppuccin/nvim#integrations
    nvimtree = true,
    hop = true,
    gitsigns = true,
    cmp = true,
    which_key = true,
    telescope = true,
    barbar = true,
    markdown = true,
    lsp_saga = true,
    treesitter = true,
    dashboard = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
  },
  color_overrides = {},
  highlight_overrides = {},
})

-- 默认启用catppuccin主题
vim.cmd(":colorscheme catppuccin")