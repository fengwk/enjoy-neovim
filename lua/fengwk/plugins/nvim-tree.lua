-- https://github.com/kyazdani42/nvim-tree.lua

local ok_nvim_tree, nvim_tree = pcall(require, "nvim-tree")
if not ok_nvim_tree then
  vim.notify("nvim-tree can not be required.")
  return
end

local ok_nvim_tree_api, nvim_tree_api = pcall(require, "nvim-tree.api")
if not ok_nvim_tree_api then
  vim.notify("nvim-tree.api can not be required.")
  return
end

local utils = require("fengwk.utils")

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  -- vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  -- vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  -- vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
  vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  -- vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'zh',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  -- vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', '<C-q>', api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH


  -- Mappings removed via:
  --   remove_keymaps
  --   OR
  --   view.mappings.list..action = ""
  --
  -- The dummy set before del is done for safety, in case a default mapping does not exist.
  --
  -- You might tidy things by removing these along with their default mapping.
  -- vim.keymap.set('n', 'O', '', { buffer = bufnr })
  -- vim.keymap.del('n', 'O', { buffer = bufnr })
  -- vim.keymap.set('n', '<2-RightMouse>', '', { buffer = bufnr })
  -- vim.keymap.del('n', '<2-RightMouse>', { buffer = bufnr })
  -- vim.keymap.set('n', 'D', '', { buffer = bufnr })
  -- vim.keymap.del('n', 'D', { buffer = bufnr })
  -- vim.keymap.set('n', 'E', '', { buffer = bufnr })
  -- vim.keymap.del('n', 'E', { buffer = bufnr })


  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  -- vim.keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
  -- vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  -- vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
  -- vim.keymap.set('n', 'P', function()
  --   local node = api.tree.get_node_under_cursor()
  --   print(node.absolute_path)
  -- end, opts('Print Node Path'))

  -- vim.keymap.set('n', 'Z', api.node.run.system, opts('Run System'))

end

-- :h nvim-tree-setup
local config = {
  on_attach = on_attach,
  sort_by = "case_sensitive", -- 文件按照字符排序，大小写敏感
  sync_root_with_cwd = true, -- 使root与cwd保持一致
  view = {
    adaptive_size = true, -- 根据文件名自适应宽度
    width = {
      max = 40, -- 设置最大宽度
    },
    -- number = true, -- 等效于 set nu
    -- relativenumber = true, -- 等效于 set rnu
    mappings = {
      custom_only = true, -- 仅使用自定义快捷键映射
    },
  },
  system_open = {
	  cmd = "xdg-open",
  },
  renderer = {
    add_trailing = false,
    group_empty = true, -- 这个选项如果为true能将空白的目录收起成一行，例如/fun/fengwk/utils作为一个整体成为单独一行
    highlight_git = false,
    full_name = false,
    highlight_opened_files = "none",
    root_folder_modifier = ":~",
    indent_width = 2,
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "",
          untracked = "",
          deleted = "✖",
          ignored = "",
        },
      },
    },
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    symlink_destination = true,
  },
  filters = {
    -- dotfiles = true, -- 过滤.文件
  },
}

-- 适配tty
if utils.is_tty() then
  config.renderer.icons = {
    webdev_colors = false,
    show = { file = false, folder = true, folder_arrow = false, git = false },
    glyphs = { default = "f", symlink = "l", bookmark = "b", folder = { arrow_closed = ">", arrow_open = "v", default = "d", open = "d", empty = "d", empty_open = "d", symlink = "l", symlink_open = "l" } }
  }
end

nvim_tree.setup(config)

-- 展开或关闭NvimTree，如果是展开将定位到文件对应的NvimTree位置
vim.keymap.set("n", "<leader>e", function()
  nvim_tree_api.tree.toggle({
    focus = true,
    find_file = true,
  })
end, { desc = "NvimTree Find File Toggle" })

-- 如果没有打开则打开NvimTree，然后定位到相应文件的位置
vim.keymap.set("n", "<leader>E", function()
  nvim_tree_api.tree.open({
    find_file = true,
  })
end, { desc = "NvimTree Find File Toggle" })