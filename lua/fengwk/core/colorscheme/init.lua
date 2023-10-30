require("fengwk.core.colorscheme.github-nvim-theme")
require("fengwk.core.colorscheme.catppuccin")
require("fengwk.core.colorscheme.vscode")
local gruvbox_flat = require("fengwk.core.colorscheme.gruvbox-flat")

local function set_hi(name, fg, bg)
  local cmd = ""
  if fg then
    cmd = cmd .. " guifg=" .. string.format("#%x", fg)
  end
  if bg then
    cmd = cmd .. " guibg=" .. string.format("#%x", bg)
  end
  if cmd and string.len(cmd) > 0 then
    cmd = "hi " .. name .. cmd
    vim.cmd(cmd)
  end
end

local function on_change_pre(colorscheme)
  -- 默认使用的混合效果
  -- vim.o.winblend = 15
  -- 默认使用dark效果
  vim.o.bg = "dark"
  -- 先清理所有高亮样式
  vim.cmd [[
    hi clear
    if exists("syntax_on")
      syntax reset
    endif
  ]]

  if colorscheme == "gruvbox" then
    -- vim.o.bg = "light"
  elseif colorscheme == "everforest" then
    -- everforest透明背景
    vim.g.everforest_transparent_background = 1
  elseif colorscheme == "gruvbox-material" then
    vim.g.loaded_gruvbox_material = 0 -- 修复gruvbox-material无法重复加载的问题
  elseif colorscheme == "catppuccin" then
    -- 透明背景无法混合
    -- vim.o.winblend = 0
  end

  -- TODO 暂时没找到方法刷新所有ui
  -- 刷新telescope winblend
  -- local ok_telescope_config, telescope_config = pcall(require, "telescope.config")
  -- if ok_telescope_config then
  --   telescope_config.set_defaults({
  --     winblend = vim.o.winblend,
  --   })
  -- end
end

-- 检查是否有指定的高亮组
local function has_highlight_group(group_name)
    local hl = vim.api.nvim_get_hl(0, { name = group_name} )
    return hl and vim.tbl_count(hl) > 0
end

local function on_changed(colorscheme)
  -- 统一nui样式
  vim.cmd([[
    set winhighlight=Normal:Normal,FloatBorder:FloatBorder,SignColumn:MySignColumn,FoldColumn:MyFoldColumn
  ]])

  -- 设置所有定义色统一样式
  local normal_hl = vim.api.nvim_get_hl_by_name('Normal', true)
  local normal_bg = normal_hl.background

  local sign_colum_fg = vim.api.nvim_get_hl_by_name('SignColumn', true).foreground
  vim.cmd "hi clear MySignColumn"
  set_hi("MySignColumn", sign_colum_fg, normal_bg)

  local fold_column_fg = vim.api.nvim_get_hl_by_name('FoldColumn', true).foreground
  vim.cmd "hi clear MyFoldColumn"
  set_hi("MyFoldColumn", fold_column_fg, normal_bg)

  vim.cmd[[
    hi clear NormalFloat
    hi link NormalFloat Normal
    hi clear LspInfoBorder
    hi link LspInfoBorder FloatBorder
  ]]

  if has_highlight_group("TelescopeBorder") then
    vim.cmd [[
      hi clear FloatBorder
      hi link FloatBorder TelescopeBorder
    ]]
  elseif has_highlight_group("TelescopePreviewBorder") then
    vim.cmd [[
      hi clear TelescopeBorder
      hi link TelescopeBorder TelescopePreviewBorder
      hi clear FloatBorder
      hi link FloatBorder TelescopePreviewBorder
    ]]
  elseif has_highlight_group("TelescopeNormal") then
    vim.cmd [[
      hi clear TelescopeBorder
      hi link TelescopeBorder TelescopeNormal
      hi clear FloatBorder
      hi link FloatBorder TelescopeNormal
    ]]
  else
    vim.cmd [[
      hi clear TelescopeBorder
      hi link TelescopeBorder Normal
      hi clear FloatBorder
      hi link FloatBorder Normal
    ]]
  end

  if has_highlight_group("TelescopeTitle") then
    vim.cmd [[
      hi clear Title
      hi link Title TelescopeTitle
      hi clear FloatTitle
      hi link FloatTitle TelescopeTitle
    ]]
  elseif has_highlight_group("TelescopeNormal") then
    vim.cmd [[
      hi clear TelescopeTitle
      hi link TelescopeTitle TelescopeNormal
      hi clear Title
      hi link Title TelescopeNormal
      hi clear FloatTitle
      hi link FloatTitle TelescopeNormal
    ]]
  else
    vim.cmd [[
      hi clear TelescopeTitle
      hi link TelescopeTitle Normal
      hi clear Title
      hi link Title Normal
      hi clear FloatTitle
      hi link FloatTitle Normal
    ]]
  end

  if colorscheme == "gruvbox" then
    require("fengwk.plugins.lualine").setup({ options = { theme = "gruvbox" } })
  elseif colorscheme == "gruvbox-material" then
    -- 添加当前搜索区域背景样式
    vim.cmd [[
      hi clear CurSearch
      hi link CurSearch IncSearch
    ]]
    -- 支持GitSign
    vim.cmd [[
      hi clear GitSignsAdd
      hi link GitSignsAdd GitGutterAdd
      hi clear GitSignsChange
      hi link GitSignsChange GitGutterChange
      hi clear GitSignsDelete
      hi link GitSignsDelete GitGutterDelete
    ]]
    require("fengwk.plugins.lualine").setup({ options = { theme = "auto" } })
  elseif colorscheme == "my-darkplus" or colorscheme == "darkplus" or colorscheme == "vscode" then
    vim.cmd "highlight NvimTreeIndentMarker guifg=#569BD5"
    vim.cmd "hi link CurSearch IncSearch"
    require "fengwk.plugins.lualine".setup({ options = { theme = "onedark" } })
  elseif colorscheme == "everforest" then
    require("fengwk.plugins.lualine").setup({ options = { theme = "everforest" } })
  elseif colorscheme == "nightfly" then
    vim.cmd "highlight NvimTreeIndentMarker guifg=#3FC5FF"
    require("fengwk.core.colorscheme.lualine-nightfly").setup()
  elseif colorscheme == "kanagawa" then
    require("fengwk.core.colorscheme.lualine-kanagawa").setup()
  elseif colorscheme == "catppuccin" then
    require("fengwk.plugins.lualine").setup({ options = { theme = "catppuccin" } })
  elseif colorscheme == "gruvbox-flat" then
    vim.cmd [[
      hi clear TelescopePromptPrefix
      hi link TelescopePromptPrefix TelescopeNormal
      hi clear TelescopePromptNormal
      hi link TelescopePromptNormal TelescopeNormal
      hi clear TelescopePreviewTitle
      hi link TelescopePreviewTitle TelescopeNormal
      hi clear TelescopePromptTitle
      hi link TelescopePromptTitle TelescopeNormal
      hi clear TelescopeResultsTitle
      hi link TelescopeResultsTitle TelescopeNormal
      hi clear TelescopePreviewBorder
      hi link TelescopeBorder TelescopeBorder
      hi clear TelescopePromptBorder
      hi link TelescopePromptBorder TelescopeBorder
      hi clear TelescopeResultsBorder
      hi link TelescopeResultsBorder TelescopeBorder
      hi link CurSearch IncSearch
      " undercurl
      hi clear DiagnosticUnderlineError
      hi link DiagnosticUnderlineError LspDiagnosticsUnderlineError
      hi clear DiagnosticUnderlineWarn
      hi link DiagnosticUnderlineWarn LspDiagnosticsUnderlineWarning
      hi clear DiagnosticUnderlineInfo
      hi link DiagnosticUnderlineInfo LspDiagnosticsUnderlineInformation
      hi clear DiagnosticUnderlineHint
      hi link DiagnosticUnderlineHint LspDiagnosticsUnderlineHint
    ]]
    gruvbox_flat.setup()
  elseif colorscheme == "github_dimmed" or string.find(colorscheme, "^github_dark") then
    require("fengwk.plugins.lualine").setup({ options = { theme = "material" } })
  else
    require("fengwk.plugins.lualine").setup({ options = { theme = "auto" } })
  end
end

vim.api.nvim_create_augroup("user_theme", { clear = true })
vim.api.nvim_create_autocmd(
  { "ColorSchemePre" },
  { group = "user_theme", pattern = "*", callback = function()
    on_change_pre(vim.fn.expand("<amatch>"))
  end}
)
vim.api.nvim_create_autocmd(
  { "ColorScheme" },
  { group = "user_theme", pattern = "*", callback = function()
    on_changed(vim.fn.expand("<amatch>"))
  end}
)

-- vim.cmd("colorscheme doom-one")
-- vim.cmd("colorscheme tokyonight")
-- vim.cmd("colorscheme neon")
-- vim.cmd("colorscheme nightfly")
-- vim.cmd("colorscheme my-darkplus")
-- vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme vscode")
-- vim.cmd("colorscheme github_dark_tritanopia")
-- vim.cmd("colorscheme melange")
-- vim.cmd("colorscheme nord")
-- vim.cmd("colorscheme catppuccin")
-- vim.cmd("colorscheme everforest")
-- vim.cmd("colorscheme material")
-- vim.cmd("colorscheme github_dark_dimmed")
-- vim.cmd("colorscheme github_dark")
-- vim.cmd("colorscheme github_dark_tritanopia")
vim.cmd("colorscheme gruvbox-flat")
-- vim.cmd("colorscheme nightfly")
