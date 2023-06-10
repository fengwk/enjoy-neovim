-- https://github.com/MattesGroeger/vim-bookmarks

local ok_utils, utils = pcall(require, "fengwk.utils")
if not ok_utils then
  vim.notify("fengwk.utils not found")
  return
end

vim.g.bookmark_no_default_key_mappings = 1 -- 不使用默认的映射
vim.g.bookmark_auto_save_file = utils.fs_concat({ vim.fn.stdpath("cache"), "vim-bookmarks" })

local keymap = vim.keymap
keymap.set("n", "<leader>mm", "<Cmd>BookmarkToggle<CR>", { silent = true, desc = "Bookmark Toggle" })
keymap.set("n", "<leader>mi", "<Cmd>BookmarkAnnotate<CR>", { silent = true, desc = "Bookmark Annotate" })
keymap.set("n", "<leader>mn", "<Cmd>BookmarkNext<CR>", { silent = true, desc = "Bookmark Next" })
keymap.set("n", "<leader>mp", "<Cmd>BookmarkPrev<CR>", { silent = true, desc = "Bookmark Prev" })
keymap.set("n", "<leader>ma", "<Cmd>Telescope vim_bookmarks all theme=dropdown<CR>", { silent = true, desc = "Bookmark Show All" })
keymap.set("n", "<leader>mA", "<Cmd>Telescope vim_bookmarks current_file theme=dropdown<CR>", { silent = true, desc = "Bookmark Show All" })
keymap.set("n", "<leader>mc", "<Cmd>BookmarkClear<CR>", { silent = true, desc = "Bookmark Clear" })
keymap.set("n", "<leader>mx", "<Cmd>BookmarkClearAll<CR>", { silent = true, desc = "Bookmark Clear All" })
