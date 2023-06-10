local actions = require("telescope.actions")

local M = {}

M.map_select_one = function(map, on_select)
  map({ "i" }, "<C-n>", actions.cycle_history_next)
  map({ "i" }, "<C-p>", actions.cycle_history_prev)
  map({ "n", "i" }, "<C-j>", actions.move_selection_next)
  map({ "n", "i" }, "<C-k>", actions.move_selection_previous)
  map({ "n", "i" }, "<CR>", on_select)
  map({ "n", "i" }, "<C-c>", actions.close)
  map({ "n", "i" }, "<C-q>", actions.close)
end

M.map_select_many = function(map, on_select)
  M.map_select_one(map, on_select)
  map({ "n", "i" }, "<Tab>", actions.toggle_selection + actions.move_selection_worse)
  map({ "n", "i" }, "<S-Tab>", actions.toggle_selection + actions.move_selection_better)
  map({ "n", "i" }, "<C-a>", actions.toggle_all)
end

return M