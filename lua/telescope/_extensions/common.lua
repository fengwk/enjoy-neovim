local actions = require("telescope.actions")

local M = {}

M.map_preview = function(map)
  map({ "n", "i" }, "<C-u>", actions.preview_scrolling_up)
  map({ "n", "i" }, "<C-d>", actions.preview_scrolling_down)
end

M.map_select_one = function(map, on_select)
  map({ "i" }, "<C-w>", { "<c-s-w>", type = "command" })
  map({ "i" }, "<C-n>", actions.cycle_history_next)
  map({ "i" }, "<C-p>", actions.cycle_history_prev)
  map({ "i" }, "<PageUp>", actions.results_scrolling_up)
  map({ "i" }, "<PageDown>", actions.results_scrolling_down)
  map({ "n" }, "j", actions.move_selection_next)
  map({ "n" }, "k", actions.move_selection_previous)
  map({ "n" }, "H", actions.move_to_top)
  map({ "n" }, "M", actions.move_to_middle)
  map({ "n" }, "L", actions.move_to_bottom)
  map({ "n" }, "<Esc>", actions.close)
  map({ "n", "i" }, "<C-j>", actions.move_selection_next)
  map({ "n", "i" }, "<C-k>", actions.move_selection_previous)
  map({ "n", "i" }, "<CR>", on_select)
  map({ "n", "i" }, "<C-c>", actions.close)
end

M.map_select_many = function(map, on_select)
  M.map_select_one(map, on_select)
  map({ "n", "i" }, "<Tab>", actions.toggle_selection + actions.move_selection_worse)
  map({ "n", "i" }, "<S-Tab>", actions.toggle_selection + actions.move_selection_better)
  map({ "n", "i" }, "<C-Tab>", actions.toggle_all)
end

return M
