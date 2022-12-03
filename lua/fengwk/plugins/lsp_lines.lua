-- https://git.sr.ht/~whynothugo/lsp_lines.nvim

local ok, lsp_lines = pcall(require, "lsp_lines")
if not ok then
  return
end

lsp_lines.setup()

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { only_current_line = true },
  -- virtual_lines = true,
})