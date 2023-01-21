-- https://github.com/stevearc/aerial.nvim

local ok, aerial = pcall(require, "aerial")
if not ok then
  return
end

local utils = require("fengwk.utils")

aerial.setup({
  -- Call this function when aerial attaches to a buffer.
  -- Useful for setting keymaps. Takes a single `bufnr` argument.
  on_attach = function(bufnr)
    local keymap = vim.keymap
    local opts = { silent = true, buffer = bufnr }
    -- Toggle the aerial window with <leader>a
    keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", opts)
    -- Jump forwards/backwards with "{" and "}"
    keymap.set("n", "{", function() aerial.prev() end, opts)
    keymap.set("n", "}", function() aerial.next() end, opts)
    -- Jump up the tree with "[[" or "]]"
    keymap.set("n", "[[", function() aerial.prev_up() end, opts)
    keymap.set("n", "]]", function() aerial.next_up() end, opts)
  end,

  -- Priority list of preferred backends for aerial.
  -- This can be a filetype map (see :help aerial-filetype-map)
  backends = { "lsp" },

  layout = {
    -- These control the width of the aerial window.
    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a list of mixed types.
    -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
    -- max_width = { 0.25 },
    width = 0.25,
  },

  disable_max_lines = utils.get_large_file_lines_threshold(), -- 超过行阈值关闭该功能
  disable_max_size = utils.get_large_file_size_threshold(), -- 超过文件大小阈值关闭该功能

  -- A list of all symbols to display. Set to false to display all symbols.
  -- This can be a filetype map (see :help aerial-filetype-map)
  -- To see all available values, see :help SymbolKind
  -- filter_kind = false,
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
    "Field",
    "Property",
    "Constant",
    "Enum",
    "EnumMember",
  },
})