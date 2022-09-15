-- https://github.com/md-img-paste-devs/md-img-paste.vim

-- 初始化图片目录
local function init_paste_dir()
  -- 重置图片目录
  -- :p:h 获取目录
  -- :t   获取文件名
  -- :t:r 获取无后缀文件名
  local imgdir = vim.fn.expand('%:t:r') .. '.assets'
  vim.g.mdip_imgdir = imgdir
end

-- 注册复制图片快捷键
vim.api.nvim_set_keymap('n', '<leader>p', ':call mdip#MarkdownClipboardImage()<CR>', { noremap = true, silent = true })

-- 每次切换缓冲区都重置初始化设置
vim.api.nvim_create_autocmd(
  { 'BufCreate' },
  { pattern = '*.md', callback = init_paste_dir }
)
vim.api.nvim_create_autocmd(
  { 'BufEnter' },
  { pattern = '*.md', callback = init_paste_dir }
)
vim.api.nvim_create_autocmd(
  { 'BufLeave' },
  { pattern = '*.md', callback = init_paste_dir }
)