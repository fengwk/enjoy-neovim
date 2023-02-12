local utils = require("fengwk.utils")
local stdpath_config = vim.fn.stdpath("config")

local format_json = utils.fs_concat({ stdpath_config, "lib", "format-json.py" })
local mode_range_map = {
  v = "'<,'>",
  l = "line(\".\")",
  n = "%",
}
local function gen_format_json_cmd(mode)
  return ":" .. mode_range_map[mode] .. "!python " .. format_json .. "<CR>"
end

vim.api.nvim_create_augroup("user_json", { clear = true })
vim.api.nvim_create_autocmd(
  { "FileType" },
  { group = "user_json", pattern = "json", callback = function()
    vim.keymap.set("n", "<leader>fm", gen_format_json_cmd("n"), { silent = true, buffer = 0 })
    vim.keymap.set("x", "<leader>fm", gen_format_json_cmd("v"), { silent = true, buffer = 0 })
  end })