-- https://nvimdev.github.io/lspsaga/
local ok, lspsaga = pcall(require, "lspsaga")
if not ok then
  return
end

lspsaga.setup({
  ui = {
    border = vim.g.__border,
    devicon = true,
    title = true,
    expand = '⊞',
    collapse = '⊟',
    code_action = '💡',
    actionfix = ' ',
    lines = { '└', '├', '│', '─', '┌' },
    kind = nil,
    imp_sign = '󰳛 ',
  },
  symbol_in_winbar = {
    enable = false,
    show_file = false,
    color_mode = false,
    dely = 10,
  },
  lightbulb = {
    enable = false,
  },
  finder = {
    keys = {
      shuttle = '<Tab>',
      toggle_or_open = 'o',
      vsplit = '<C-v>',
      split = '<C-x>',
      tabe = '<C-t>',
      tabnew = '<C-T>',
      quit = 'q',
      close = '<C-c>',
    },
  },
  definition = {
    keys = {
      edit = '<C-e>',
      vsplit = '<C-v>',
      split = '<C-x>',
      tabe = '<C-t>',
      quit = 'q',
      close = '<C-c>',
    },
  },
  rename = {
    keys = {
      quit = '<C-c>',
      exec = '<CR>',
    },
  },
  outline = {
    win_position = 'right',
    win_width = 45,
    auto_preview = true,
    detail = true,
    auto_close = true,
    close_after_jump = false,
    layout = 'normal',
    max_height = 0.5,
    left_width = 0.3,
    keys = {
      toggle_or_jump = 'o',
      quit = 'q',
      jump = '<Enter>',
    },
  },
  callhierarchy = {
    layout = 'float',
    left_width = 0.2,
    keys = {
      edit = '<Enter>',
      vsplit = '<C-v>',
      split = '<C-x>',
      tabe = '<C-t>',
      close = '<C-c>',
      quit = 'q',
      shuttle = '<Tab>',
      toggle_or_req = 'o',
    },
  },
  beacon = {
    enable = false,
  },
})

vim.keymap.set({ "n", "t" }, "``", "<Cmd>Lspsaga term_toggle<CR>", { desc = "Float Terminal" })
vim.keymap.set({ "n", "t" }, "`<Enter>", function ()
  vim.api.nvim_command("Lspsaga term_toggle " .. os.getenv("SHELL") .. " " .. vim.fn.expand("%:p:h"))
end, { desc = "Float Terminal On Current Buffer Directory" })
