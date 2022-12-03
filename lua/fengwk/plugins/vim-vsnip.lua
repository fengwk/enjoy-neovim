-- https://github.com/hrsh7th/vim-vsnip

local utils = require "fengwk.utils"

-- 指定个人snippets文件夹位置
vim.g.vsnip_snippet_dir = utils.fs_concat({ vim.fn.stdpath("config"), "my-snippets" })
-- print(vim.g.vsnip_snippet_dir)
-- table.insert( vim.g.vsnip_snippet_dirs, utils.fs_concat({ vim.fn.stdpath("config"), "my-snippets" }))

-- snippets补全后会进入select模式，编辑会进入insert模式，指定在这两个模式下的跳跃
vim.cmd([[
  " Jump forward or backward
  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]])