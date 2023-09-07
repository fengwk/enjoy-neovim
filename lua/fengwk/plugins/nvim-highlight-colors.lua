-- https://github.com/brenoprata10/nvim-highlight-colors
local ok, nvim_highlight_colors = pcall(require, "nvim-highlight-colors")
if not ok then
  return
end

nvim_highlight_colors.setup()
