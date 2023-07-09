local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

local setup_opts = {}

local function diffspliit(prompt_bufnr, vert, pre_func)
  actions.close(prompt_bufnr)
  if pre_func then
    pre_func()
  end
  local selection = action_state.get_selected_entry()
  local path = selection.path
  if vert then
    vim.cmd("vertical diffsplit " .. path)
  else
    vim.cmd("diffsplit " .. path)
  end
end

local function diff_file(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  opts = vim.tbl_deep_extend("force", setup_opts, opts or {}, {
    prompt_title = "Pick file to diff",
    attach_mappings = function(_, map)
      map({ "n", "i" }, "<CR>", function(prompt_bufnr)
        diffspliit(prompt_bufnr, true)
      end)
      map({ "n", "i" }, "<C-x>", function(prompt_bufnr)
        diffspliit(prompt_bufnr, false)
      end)
      map({ "n", "i" }, "<C-v>", function(prompt_bufnr)
        diffspliit(prompt_bufnr, true)
      end)
      map({ "n", "i" }, "<C-t>", function(prompt_bufnr)
        diffspliit(prompt_bufnr, true, function()
          vim.cmd.tabnew(vim.fn.expand(vim.api.nvim_buf_get_name(bufnr)))
        end)
      end)
      return true
    end,
    bufnr = bufnr,
    hidden = false,
    no_ignore = false,
    no_ignore_parent = false,
  })
  builtin.find_files(opts)
end

return require("telescope").register_extension({
  setup = function (opts)
    if opts and #opts >= 1 then
      setup_opts = opts[1]
    end
  end,
  exports = {
    diff_file = diff_file,
  },
})
