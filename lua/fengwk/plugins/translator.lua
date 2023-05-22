-- https://github.com/voldikss/vim-translator

-- 检查str是否为中文
local function isChinese(str)
  local utf8 = require("utf8")
  local totalCount = 0
  local chineseCount = 0
  local p, c = utf8.next(str, 1)
  while p do
    local char = utf8.char(c)
    if string.match(char, "[%z\1-\127\194-\244][\128-\191]") then
      chineseCount = chineseCount + 1
    end
    totalCount = totalCount + 1
    p, c = utf8.next(str, p)
  end
  return (chineseCount / totalCount) > 0.6
end

-- 在无法翻墙的情况下可以使用haici作为替代方案，不过haici只能翻译单词
-- vim.keymap.set("n", "<leader>t", ":Translate --engines=haici<CR>", { silent = true, desc = "Translate Current Word" })
vim.keymap.set("n", "<leader>t", ":Translate --engines=google<CR>", { silent = true, desc = "Translate Current Word" })
vim.keymap.set("v", "<leader>t", ":Translate --engines=google<CR>", { silent = true, desc = "Translate Selection" })
vim.keymap.set("n", "<leader>T", function()
  vim.ui.input({ prompt = "Translate: " }, function(input)
    if input and #input > 0 then
      vim.g.translator_target_lang = isChinese(input) and "en" or "zh"
      vim.cmd("Translate --engines=google " .. input)
      vim.g.translator_target_lang = "zh"
    end
  end)
end, { silent = true, desc = "Translate Current Word" })