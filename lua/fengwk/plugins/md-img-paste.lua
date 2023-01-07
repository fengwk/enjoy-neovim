-- https://github.com/md-img-paste-devs/md-img-paste.vim

-- 设置图片目录为同名文件加.assets后缀
-- :p:h 获取目录
-- :t   获取文件名
-- :t:r 获取无后缀文件名
local imgdir = vim.fn.expand("%:t:r") .. ".assets"
vim.g.mdip_imgdir = imgdir

-- 注册复制图片快捷键
vim.keymap.set("n", "<leader>mp", ":call mdip#MarkdownClipboardImage()<CR>", { silent = true, desc = "Pates Image To Markdown" })