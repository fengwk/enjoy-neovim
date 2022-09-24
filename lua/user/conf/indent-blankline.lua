-- https://github.com/lukas-reineke/indent-blankline.nvim
require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true, -- 如果为true突出当前区域缩进线
    show_current_context_start = false, -- 如果为true突出当前区域开始位置
}