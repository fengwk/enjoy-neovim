-- https://github.com/kana/vim-textobj-user

vim.cmd[[
" Define ad/id to select a date such as 2013-03-16, and define at/it to select a time such as 22:04:21:
call textobj#user#plugin('datetime', {
\   'date': {
\     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
\     'select': ['add', 'id'],
\   },
\   'time': {
\     'pattern': '\<\d\d:\d\d:\d\d\>',
\     'select': ['at', 'it'],
\   },
\ })
]]