local utils = require("fengwk.utils")
local stdpath_config = vim.fn.stdpath("config")

local format_json = utils.fs_concat({ stdpath_config, "ftplugin", "format_json.py" })

vim.cmd([[
if exists('g:loaded_json_format')
  finish
endif
let g:loaded_json_format = 1

function! User_Json_Parse(mode)
  let dictCmd = {"v":"'<,'>", "l":line("."), "n":"%"}
  silent execute ":"dictCmd[a:mode]"!python ]] .. format_json .. [["
endfunction

" Format Visual Selection
xmap <silent> <leader>fm :call User_Json_Parse("v")<cr>
" Format Entire Buffer
nmap <silent> <leader>fm :call User_Json_Parse("n")<cr>
]]
)