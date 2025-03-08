-- https://github.com/hrsh7th/vim-vsnip

local utils = require("fengwk.utils")

-- 指定个人snippets文件夹位置，可以参考friendly-snippets
-- https://github.com/rafamadriz/friendly-snippets/tree/main/snippets
vim.g.vsnip_snippet_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "my-snippets")

-- snippets补全后会进入select模式，编辑会进入insert模式，指定在这两个模式下的跳跃
vim.cmd([[
  " Jump forward or backward
  imap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
  smap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
  imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
  smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
]])
