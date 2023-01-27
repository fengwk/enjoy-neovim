-- https://github.com/gcmt/wildfire.vim

-- all版本
vim.cmd([[
cal wildfire#triggers#Add("<leader><Enter>", {
  \ "*" : [
    \ "a'",
    \ 'a"',
    \ "a)",
    \ "a]",
    \ "a}",
    \ "at",
    \ "aW",
    \ "aa",
    \ "af",
    \ "ac",
    \ "aC"
  \ ],
  \ "html,xml" : [
    \ "at",
  \ ]
\ })
]])

-- in版本
vim.g.wildfire_objects = {
  ["*"] = {
    "i'",
    'i"',
    "i)",
    "i]",
    "i}",
    "it",
    "iW",
    -- "ip",
    -- treesitter-object
    "ia",
    "if",
    "ic",
    "iC",
  },
  ["html,xml"] = {
    "it",
  }
}
-- in版本键位映射
vim.keymap.set({ "n", "x" }, "<Enter>", "<Plug>(wildfire-fuel)", {})
-- 撤销选取
vim.keymap.set("x", "<BS>", "<Plug>(wildfire-water)", {})

-- quick select，禁用这个方法，在neovim中使用存在bug？导致了错误的选择
-- vim.keymap.set({ "n", "x" }, "<leader><Enter>", "<Plug>(wildfire-quick-select)", {})