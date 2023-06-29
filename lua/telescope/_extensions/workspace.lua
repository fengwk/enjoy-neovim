local ext_common = require("telescope._extensions.common")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local telescope = require("telescope")

local workspaces = require("fengwk.plugins.workspaces.workspaces")

local base_opts = {}

local open_ws = function(prompt_bufnr, before_open)
  local selected = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if not selected then
    return
  end

  local ws_name = selected.value
  if ws_name and ws_name ~= "" then
    if before_open then
      before_open()
    end
    workspaces.open(ws_name)
  end
end

local workspaces_picker = function(opts)
  local ws_list = workspaces.list()

  opts = vim.tbl_deep_extend("keep", opts or {}, base_opts, { bufnr = vim.api.nvim_get_current_buf() })

  pickers.new(opts, {
    prompt_title = "Workspaces",

    finder = finders.new_table({
      results = ws_list,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
        }
      end,
    }),

    sorter = conf.generic_sorter(opts),

    attach_mappings = function(_, map)
      ext_common.map_select_one(map, open_ws)
      map({ "n", "i" }, "<C-x>", function(prompt_bufnr)
        open_ws(prompt_bufnr, function()
          vim.cmd("sp")
        end)
      end)
      map({ "n", "i" }, "<C-v>", function(prompt_bufnr)
        open_ws(prompt_bufnr, function()
          vim.cmd("vsp")
        end)
      end)
      map({ "n", "i" }, "<C-t>", function(prompt_bufnr)
        open_ws(prompt_bufnr, function()
          vim.cmd("tabnew")
        end)
      end)
      return false
    end,
  }):find()
end

return telescope.register_extension({
  setup = function(opts)
    if opts and #opts >= 1 then
      base_opts = opts[1]
    end
  end,

  exports = {
    workspaces = function(opts)
      workspaces_picker(opts)
    end,
  },
})
