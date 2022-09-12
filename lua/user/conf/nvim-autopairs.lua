-- https://github.com/windwp/nvim-autopairs

require("nvim-autopairs").setup({
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel", "dap-repl" },
  disable_in_macro = false,
  disable_in_visualblock = true,
  fast_wrap = {
    -- map = "<M-e>", -- alt+e，快速补充右侧符号
    map = "<C-l>", -- ctrl+l，快速补充右侧符号
    chars = { "{", "[", "(", '"', "'", "`" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
})