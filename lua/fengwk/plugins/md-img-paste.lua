-- https://github.com/md-img-paste-devs/md-img-paste.vim

-- 设置图片目录为同名文件加-assets后缀
local function init_paste_dir()
  -- :p:h 获取目录
  -- :t   获取文件名
  -- :t:r 获取无后缀文件名
  local imgdir = vim.fn.expand("%:t:r") .. "-assets"
  vim.g.mdip_imgdir = imgdir
  vim.g.mdip_imgdir_intext = imgdir
end

-- 使用自动命令初始化黏贴目录
vim.api.nvim_create_augroup("user_init_paste_dir", { clear = true })
vim.api.nvim_create_autocmd(
  { "BufCreate", "BufEnter" },
  { group = "user_init_paste_dir", pattern = "*.md", callback = init_paste_dir }
)

-- 注册复制图片快捷键
vim.keymap.set("n", "<leader>mp", "<Cmd>call mdip#MarkdownClipboardImage()<CR>", { silent = true, desc = "Pates Image To Markdown" })