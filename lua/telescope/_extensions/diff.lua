local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

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
  opts = opts or {}
  local local_opts = {
    prompt_title = "Pick file to diff",
    attach_mappings = function(_, map)
      map({"n", "i"}, "<CR>", function(prompt_bufnr)
        diffspliit(prompt_bufnr, true)
      end)
      map({"n", "i"}, "<C-x>", function(prompt_bufnr)
        diffspliit(prompt_bufnr, false)
      end)
      map({"n", "i"}, "<C-v>", function(prompt_bufnr)
        diffspliit(prompt_bufnr, true)
      end)
      map({"n", "i"}, "<C-t>", function(prompt_bufnr)
        diffspliit(prompt_bufnr, true, function()
          vim.cmd.tabnew(vim.fn.expand(vim.api.nvim_buf_get_name(opts.bufnr)))
        end)
      end)
      return true
    end,
  }
  opts = vim.tbl_extend("force", opts, local_opts)
  builtin.find_files(opts)
end

return require("telescope").register_extension({
  exports = {
    diff_file = diff_file,
  },
})