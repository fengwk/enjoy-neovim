-- https://github.com/gcmt/wildfire.vim
vim.g.wildfire_objects = {
  ["*"] = {
    "i'",
    'i"',
    "i)",
    "i]",
    "i}",
    -- "ip",
    "it",
    "a'",
    'a"',
    "a)",
    "a]",
    "a}",
    "at",
    -- "ap",
    "at",
    -- treesitter-object
    "ia",
    "if",
    "ic",
    "aa",
    -- "af",
    -- "ac",
  },
  ["html,xml"] = { "at", "it" }
}

vim.cmd [[
nnoremap <leader><Enter> <Plug>(wildfire-quick-select)
]]