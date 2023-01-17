-- https://github.com/gcmt/wildfire.vim
vim.g.wildfire_objects = {
  ["*"] = {
    "i'",
    'i"',
    "i)",
    "i]",
    "i}",
    "it",
    -- "ip",
    -- "a'",
    -- 'a"',
    -- "a)",
    -- "a]",
    -- "a}",
    -- "at",
    -- "ap",
    -- "at",
    -- treesitter-object
    "ia",
    "if",
    "ic",
    -- "aa",
    -- "af",
    -- "ac",
    "iC",
  },
  ["html,xml"] = {
    "at",
    "it",
  }
}

vim.cmd [[
" This selects the next closest text object.
nmap <Enter> <Plug>(wildfire-fuel)
" This selects the previous closest text object.
" xmap <leader><Enter> <Plug>(wildfire-water)

" quick select
" nmap <leader><Enter> <Plug>(wildfire-quick-select)
]]