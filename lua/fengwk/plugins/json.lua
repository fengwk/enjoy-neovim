local utils = require "fengwk.utils"

local format_json = utils.fs.stdpath("config", "lib/format-json.py")
local mode_range_map = {
  v = "'<,'>",
  l = "line(\".\")",
  n = "%",
}
local function gen_format_json_cmd(mode)
  local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth") or 4
  return mode_range_map[mode] .. "!python3 " .. format_json .. " -i " .. shiftwidth
end

vim.api.nvim_create_augroup("user_json", { clear = true })
vim.api.nvim_create_autocmd(
  { "FileType" },
  {
    group = "user_json",
    pattern = "json,jsonc",
    callback = function()
      vim.keymap.set("n", "<leader>fm", function() vim.cmd(gen_format_json_cmd("n")) end, { silent = true, buffer = 0 })
      vim.keymap.set("x", "<leader>fm", function() vim.cmd(gen_format_json_cmd("v")) end, { silent = true, buffer = 0 })
    end
  })
