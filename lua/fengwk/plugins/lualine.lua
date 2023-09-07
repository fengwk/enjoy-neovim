-- https://github.com/nvim-lualine/lualine.nvim

local ok_lualine, lualine = pcall(require, "lualine")
if not ok_lualine then
  vim.notify("lualine can not be required.")
  return
end

-- 格式化信息样式
local function format_messages(messages)
  local result = {}
  local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  local i = 1
  for _, message in pairs(messages) do
    -- Only display at most 2 progress messages at a time to avoid clutter
    if i < 3 then
      table.insert(result, (message.percentage or 0) .. "%% " .. (message.title or ""))
      i = i + 1
    end
  end
  return table.concat(result, " ") .. " " .. spinners[frame + 1]
end

-- lsp信息
function _G._lualine_lsp_progress()
  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then
    return ""
  end
  return " " .. format_messages(messages)
end

-- 诊断信息
local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " ", info = " ", hint = "" },
  colored = false,
  update_in_insert = false,
  always_visible = false,
}

-- https://github.com/stevearc/aerial.nvim#lualine
-- local aerial = {
--   "aerial",
--   dense = true,
--   dense_sep = " > ",
--   colored = false,
-- }

local M = {}

M.symbol_bar = function()
  local ok, wb = pcall(require, "lspsaga.symbol.winbar")
  if not ok then
    return ""
  end
  local bar = wb.get_bar()
  if not bar then
    return ""
  end
  -- 去除颜色高亮
  bar, _ = bar:gsub("%%**%%#[^#]+#", "")
  bar, _ = bar:gsub("%%#[^#]+#", "")
  return bar
end

M.setup = function(opts)
  opts = opts or {}

  opts = vim.tbl_deep_extend("force", {
    options = {
      icons_enabled = true,
      -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        "packer", "NvimTree", "toggleterm", "TelescopePrompt", "qf", "aerial",
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "filename", "branch", diagnostics },
      lualine_c = { "require('fengwk.plugins.lualine').symbol_bar()", "require('dap').status()", "_G._lualine_lsp_progress()" },
      lualine_x = { "encoding" },
      lualine_y = { "progress" },
      lualine_z = { "location" }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }, opts)

  lualine.setup(opts)
end

return M
