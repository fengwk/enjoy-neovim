-- https://github.com/projekt0n/github-nvim-theme

require("github-theme").setup({
  theme_style = "light", -- dark/dimmed/dark_default/dark_colorblind/light/light_default/light_colorblind
  function_style = "italic",
  sidebars = { "packer", "NvimTree", "toggleterm", "TelescopePrompt", "qf", "aerial" },
  dark_sidebar = true, -- Sidebar like windows like NvimTree get a darker background
  hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard StatusLine.

  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
  colors = {hint = "orange", error = "#ff0000"},

  -- Overwrite the highlight groups
  overrides = function(c)
    return {
      htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
      DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
      -- this will remove the highlight groups
      TSField = {},
    }
  end,
  transparent = false, -- Enable this to disable setting the background color
})