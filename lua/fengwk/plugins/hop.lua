-- https://github.com/phaazon/hop.nvim

local ok, hop = pcall(require, "hop")
if not ok then
  return
end

-- you can configure Hop the way you like here; see :h hop-config
hop.setup({ keys = "etovxqpdygfblzhckisuran" })

-- see :h hop-extension
-- place this in one of your configuration file(s)
-- vim.api.nvim_set_keymap('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
-- vim.api.nvim_set_keymap('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
-- vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
-- vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})
vim.keymap.set("", "<leader><leader>", "<Cmd>lua require('hop').hint_char1({ current_line_only = false })<CR>", { silent = true, desc = "Hop" })