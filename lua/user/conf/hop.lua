-- https://github.com/phaazon/hop.nvim

-- you can configure Hop the way you like here; see :h hop-config
-- require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
require("hop").setup({ keys = "qwerasdfzxcv" })

-- see :h hop-extension
-- place this in one of your configuration file(s)
-- vim.keymap.set("", "f", "<cmd>lua require"hop".hint_char1({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
-- vim.keymap.set("", "F", "<cmd>lua require"hop".hint_char1({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.keymap.set("", "<leader><leader>", "<Cmd>lua require('hop').hint_char1({ current_line_only = false })<CR>", { noremap = true, silent = true, desc = "Hop" })