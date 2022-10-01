-- https://github.com/nvim-lualine/lualine.nvim

local lualine = require "lualine"

local function format_messages(messages)
  local result = {}
  local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  local i = 1
  for _, msg in pairs(messages) do
    -- Only display at most 2 progress messages at a time to avoid clutter
    if i < 3 then
      table.insert(result, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
      i = i + 1
    end
  end
  return table.concat(result, " ") .. " " .. spinners[frame + 1]
end

function _G._lualine_lsp_progress()
  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then
    return ""
  end
  return " " .. format_messages(messages)
end

-- function _G._lualine_lsp_status()
--   if vim.lsp.buf_get_clients() > 0 then
--     return require("lsp-status").status()
--   end
--   return ""
-- end

-- 诊断信息
local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = false,
}

lualine.setup {
  options = {
    icons_enabled = true,
    -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
    -- theme = "auto",
    theme = "onedark",
    -- theme = "palenight",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      "NvimTree", "toggleterm", "packer",
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
    lualine_c = { "_G._lualine_lsp_progress()" },
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
}