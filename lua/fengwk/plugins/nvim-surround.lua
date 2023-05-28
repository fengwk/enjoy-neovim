-- https://github.com/kylechui/nvim-surround
--[[
    Old text                    Command         New text
--------------------------------------------------------------------------------
    surr*ound_words             ysiw)           (surround_words)
    *make strings               ys$"            "make strings"
    [delete ar*ound me!]        ds]             delete around me!
    remove <b>HTML t*ags</b>    dst             remove HTML tags
    'change quot*es'            cs'"            "change quotes"
    <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    delete(functi*on calls)     dsf             function calls
]]

local ok, nvim_surround = pcall(require, "nvim-surround")
if not ok then
  vim.notify("nvim-surround can not be required.")
  return
end

local utils = require "fengwk.utils"

nvim_surround.setup({
  surrounds = {
    -- 自定义两侧环绕，且两侧都可自定义
    ["i"] = {
      add = function()
        local left_delimiter = utils.input({ prompt = "Enter the left delimiter: " })
        local right_delimiter = left_delimiter and utils.input({ prompt = "Enter the right delimiter: " })
        if right_delimiter then
          return { { left_delimiter }, { right_delimiter } }
        end
      end,
      find = function() end,
      delete = function() end,
    },
    -- 自定义两侧环绕
    -- ["I"] = {
    --   add = function()
    --     local delimiter = utils.input({ prompt = "Enter the delimiter: " })
    --     if delimiter then
    --       return { { delimiter }, { delimiter } }
    --     end
    --   end,
    --   find = function() end,
    --   delete = function() end,
    -- },
  }
})