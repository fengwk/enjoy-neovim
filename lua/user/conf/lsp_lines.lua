-- https://git.sr.ht/~whynothugo/lsp_lines.nvim

require("lsp_lines").setup()

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
  -- virtual_lines = { only_current_line = true },
  virtual_lines = true,
})