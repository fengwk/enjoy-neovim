-- https://github.com/nvim-treesitter/nvim-treesitter

require("nvim-treesitter.configs").setup({
  ensure_installed = {}, -- 自动安装清单，可以使用"all"安装所有解析器
  sync_install = false, -- 是否同步安装
  auto_install = true, -- 进入缓冲区时自动安装

  highlight = {
    enable = true, -- 是否开启高亮

    -- 这个函数可以定义什么情况下关闭高亮，返回true时将关闭高亮
    disable = function(lang, buf)
      -- 大json文件会使得渲染时卡顿，因此关闭高亮
      if lang == "json" then
        return true
      end
      -- 超过100kb的文件不启动高亮
      local max_filesize = 100 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
      return false
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})