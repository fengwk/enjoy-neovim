-- https://github.com/numToStr/Comment.nvim

local ok, comment = pcall(require, "Comment")
if not ok then
  return
end

-- normal mode
-- gcc 注释行
-- gc{motion} 注释motion范围内容
-- gb 注释块
-- visual mode
-- gc 注释行
-- gb 注释块
comment.setup()