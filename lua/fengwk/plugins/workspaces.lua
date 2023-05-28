local ok, ws_enhancer = pcall(require, "workspaces-enhancer")
if not ok then
  vim.notify("workspaces-enhancer can not be required.")
  return
end

ws_enhancer.setup({
  -- to change directory for all of nvim (:cd) or only for the current window (:lcd)
  -- if you are unsure, you likely want this to be true.
  global_cd = true,

  -- sort the list of workspaces by name after loading from the workspaces path.
  sort = true,

  -- sort by recent use rather than by name. requires sort to be true
  mru_sort = true,

  -- enable info-level notifications after adding or removing a workspace
  notify_info = true,
})

vim.keymap.set("n", "<leader>fs", "<Cmd>Telescope workspaces theme=dropdown<CR>", { noremap = true, silent = true, desc = "Load Workspaces" })