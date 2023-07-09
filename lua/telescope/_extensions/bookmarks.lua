local ext_common    = require "telescope._extensions.common"
local pickers       = require "telescope.pickers"
local finders       = require "telescope.finders"
local conf          = require "telescope.config".values
local actions       = require "telescope.actions"
local entry_display = require "telescope.pickers.entry_display"
local action_state  = require "telescope.actions.state"
local bookmarks     = require "fengwk.plugins.bookmarks.bookmarks"

local setup_opts    = {}

local function display_func(item)
  local displayer = entry_display.create {
    separator = " |",
    items = {
      { width = 30 },
      { width = 3 },
      { remaining = true },
    }
  }

  return displayer {
    item.value.annotation,
    item.value.row,
    item.value.filename,
  }
end

local function entry_maker_func(entry)
  return {
    value = entry,
    ordinal = entry.annotation,
    display = display_func,
    filename = entry.filename,
    lnum = entry.row,
  }
end

local open_mark = function(prompt_bufnr, before_open)
  local selected = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if selected then
    if before_open then
      before_open()
    end
    bookmarks.open_mark(selected.value.hash)
  end
end

local remove_mark = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
    current_picker:delete_selection(function(selection)
    bookmarks.remove_mark_item(selection.value.hash)
    return true
  end)
end

local function picker_func(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("keep", opts, setup_opts)
  local finder_func = function()
    return finders.new_table {
      results = bookmarks.list_marks(),
      entry_maker = entry_maker_func,
    }
  end

  pickers.new(opts, {
    prompt_title = "Bookmarks",
    finder = finder_func(),
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, map)
      ext_common.map_preview(map)
      ext_common.map_select_one(map, open_mark)
      map({ "n" }, "dd", remove_mark)
      map({ "n", "i" }, "<C-x>", function(prompt_bufnr)
        open_mark(prompt_bufnr, function()
          vim.cmd("sp")
        end)
      end)
      map({ "n", "i" }, "<C-v>", function(prompt_bufnr)
        open_mark(prompt_bufnr, function()
          vim.cmd("vsp")
        end)
      end)
      map({ "n", "i" }, "<C-t>", function(prompt_bufnr)
        open_mark(prompt_bufnr, function()
          vim.cmd("tabnew")
        end)
      end)
      return false
    end,
  }):find()
end


return require("telescope").register_extension {
  setup = function(opts)
    if opts and #opts >= 1 then
      setup_opts = opts[1]
    end
  end,
  exports = {
    bookmarks = picker_func
  }
}
