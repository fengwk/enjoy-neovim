-- https://github.com/RRethy/vim-illuminate
-- default configuration
require('illuminate').configure({
    -- providers: provider used to get references in the buffer, ordered by priority
    providers = {
        'lsp',
        -- 'treesitter',
        -- 'regex',
    },
    -- delay: delay in milliseconds
    delay = 0,
    -- filetype_overrides: filetype specific overrides.
    -- The keys are strings to represent the filetype while the values are tables that
    -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
    filetype_overrides = {},
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = { "packer", "NvimTree", "toggleterm", "TelescopePrompt", "qf", "aerial" },
    -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
    filetypes_allowlist = {},
    -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
    modes_denylist = {},
    -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
    modes_allowlist = {},
    -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_denylist = {},
    -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_allowlist = {},
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = true,
})

vim.keymap.set("n", "<C-j>", "<Cmd>lua require('illuminate').goto_next_reference()<CR>", { noremap = true, silent = true, desc = "Next Symbol" })
vim.keymap.set("n", "<C-k>", "<Cmd>lua require('illuminate').goto_prev_reference()<CR>", { noremap = true, silent = true, desc = "Prev Symbol" })
-- vim.keymap.set("n", "<Tab>", "<Cmd>lua require('illuminate').goto_next_reference()<CR>", { noremap = true, silent = true, desc = "Next Symbol" })
-- vim.keymap.set("n", "<S-Tab>", "<Cmd>lua require('illuminate').goto_prev_reference()<CR>", { noremap = true, silent = true, desc = "Prev Symbol" })

-- h: highlight-args
-- vim.cmd([[
--   hi def IlluminatedWordText cterm=bold ctermbg=red guibg=LightYellow
--   hi def IlluminatedWordRead cterm=bold ctermbg=red guibg=LightYellow
--   hi def IlluminatedWordWrite cterm=bold ctermbg=red guibg=LightYellow
-- ]])