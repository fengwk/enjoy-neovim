-- https://github.com/windwp/nvim-autopairs

local ok, nvim_autopairs = pcall(require, "nvim-autopairs")
if not ok then
  vim.notify("nvim-autopairs can not be required.")
  return
end

nvim_autopairs.setup({
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

-- 对于一些无法自动补充括号的LSP，下面的方法将增加这一功能
local ok, cmp = pcall(require, "cmp")
if ok and cmp ~= nil then
  -- If you want insert `(` after select function or method item
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local handlers = require('nvim-autopairs.completion.handlers')
  cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done({
      filetypes = {
        -- "*" is a alias to all filetypes
        ["*"] = {
          ["("] = {
            kind = {
              -- https://docs.rs/lsp/0.2.0/lsp/types/enum.CompletionItemKind.html
              cmp.lsp.CompletionItemKind.Function,
              cmp.lsp.CompletionItemKind.Method,
              cmp.lsp.CompletionItemKind.Constructor,
            },
            handler = handlers["*"],
          },
        },
        -- 禁用指定类型的LSP
        tex = false,
        sh = false,
        bash = false,
      }
    })
  )
end