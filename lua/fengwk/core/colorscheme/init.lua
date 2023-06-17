require("fengwk.core.colorscheme.vscode")
require("fengwk.core.colorscheme.catppuccin")
require("fengwk.core.colorscheme.github-nvim-theme")

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

  if colorscheme == "gruvbox" then
    -- vim.o.bg = "light"
  elseif colorscheme == "everforest" then
    -- everforest透明背景
    vim.g.everforest_transparent_background = 1
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
    set winhighlight=Normal:Normal,FloatBorder:FloatBorder,SignColumn:MySignColumn,FoldColumn:MyFoldColumn,LineNr:MyLineNr
  ]])

  -- 设置所有定义色统一样式
  local normal_hl = vim.api.nvim_get_hl_by_name('Normal', true)
  local normal_fg = normal_hl.foreground
  local normal_bg = normal_hl.background

  local sign_colum_fg = vim.api.nvim_get_hl_by_name('SignColumn', true).foreground
  vim.cmd "hi clear MySignColumn"
  set_hi("MySignColumn", sign_colum_fg, normal_bg)

  local fold_column_fg = vim.api.nvim_get_hl_by_name('FoldColumn', true).foreground
  vim.cmd "hi clear MyFoldColumn"
  set_hi("MyFoldColumn", fold_column_fg, normal_bg)

  local line_nr_fg = vim.api.nvim_get_hl_by_name('LineNr', true).foreground
  vim.cmd "hi clear MyLineNr"
  set_hi("MyLineNr", line_nr_fg, normal_bg)

  vim.cmd[[
    hi clear NormalFloat
    hi link NormalFloat Normal
  ]]

  if has_highlight_group("TelescopeBorder") then
    vim.cmd[[
      hi clear FloatBorder
      hi link FloatBorder TelescopeBorder
    ]]
  else
    vim.cmd "hi clear FloatBorder"
    set_hi("FloatBorder", nil, normal_bg)
    vim.cmd "hi clear TelescopeBorder"
    set_hi("TelescopeBorder", nil, normal_bg)
  end

  if has_highlight_group("TelescopeTitle") then
    vim.cmd[[
      hi clear Title
      hi link Title TelescopeTitle
      hi clear FloatTitle
      hi link FloatTitle TelescopeTitle
    ]]
  else
    vim.cmd "hi clear Title"
    set_hi("Title", normal_fg, normal_bg)
    vim.cmd "hi clear FloatTitle"
    set_hi("FloatTitle", normal_fg, normal_bg)
    vim.cmd "hi clear TelescopeTitle"
    set_hi("TelescopeTitle", normal_fg, normal_bg)
  end

  if colorscheme == "gruvbox" then
    require("fengwk.plugins.lualine").setup({ options = { theme = "gruvbox" } })
  elseif colorscheme == "my-darkplus" or colorscheme == "darkplus" or colorscheme == "vscode" then
    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#569BD5 ]])
    require "fengwk.plugins.lualine".setup({ options = { theme = "onedark" } })
  elseif colorscheme == "everforest" then
    require("fengwk.plugins.lualine").setup({ options = { theme = "everforest" } })
  elseif colorscheme == "nightfly" then
    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
    require("fengwk.core.colorscheme.lualine-nightfly").setup()
  elseif colorscheme == "kanagawa" then
    require("fengwk.core.colorscheme.lualine-kanagawa").setup()
  elseif colorscheme == "catppuccin" then
    require("fengwk.plugins.lualine").setup({ options = { theme = "catppuccin" } })
  elseif colorscheme == "github_dimmed" or string.find(colorscheme, "^github_dark") then
    require("fengwk.plugins.lualine").setup({ options = { theme = "onedark" } })
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
-- vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme kanagawa")
vim.cmd("colorscheme vscode")
-- vim.cmd("colorscheme github_dark_tritanopia")
-- vim.cmd("colorscheme melange")
-- vim.cmd("colorscheme nord")
-- vim.cmd("colorscheme catppuccin")
-- vim.cmd("colorscheme everforest")
-- vim.cmd("colorscheme material")
-- vim.cmd("colorscheme github_dark_dimmed")
-- vim.cmd("colorscheme github_dark")
-- vim.cmd("colorscheme nightfly")
