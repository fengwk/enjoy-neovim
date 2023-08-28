-- https://github.com/RRethy/vim-illuminate

local ok, illuminate = pcall(require, "illuminate")
if not ok then
  vim.notify("illuminate can not be required.")
  return
end

local utils = require("fengwk.utils")

illuminate.configure({
  -- 指定提供符号引用的程序，可以指定的程序有：lsp、treesitter、regex
  -- 同时指定了多个时会按照排序的优先级获取
  providers = {
    'lsp',
    -- 'treesitter',
    -- 'regex',
  },
  -- 延迟的毫秒数
  delay = 10,
  -- 文件类型黑名单
  filetypes_denylist = { "packer", "NvimTree", "toggleterm", "TelescopePrompt", "qf", "aerial" },
  -- 允许的模式列表
  modes_allowlist = { 'n' },
  -- 当文件行数大于阈值时关闭该功能
  large_file_cutoff = utils.vim.large_flines,
})

vim.keymap.set("n", "<C-j>", "<Cmd>lua require('illuminate').goto_next_reference()<CR>", { silent = true, desc = "Next Symbol" })
vim.keymap.set("n", "<C-k>", "<Cmd>lua require('illuminate').goto_prev_reference()<CR>", { silent = true, desc = "Prev Symbol" })
