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
    color_mode = true, -- 在lualine中剔除颜色标记
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

local function setup_lsp_keymap(bufnr)
    -- 当前作用域的上游（从哪些地方进来）
    vim.keymap.set("n", "<leader>gi", "<Cmd>Lspsaga incoming_calls<CR>",
      { silent = true, buffer = bufnr, desc = "Lsp Incoming Calls" })
    -- 当前作用域的下游（去到哪些地方）
    vim.keymap.set("n", "<leader>go", "<Cmd>Lspsaga outgoing_calls<CR>",
      { silent = true, buffer = bufnr, desc = "Lsp Outgoing Calls" })
    -- 打开outline
    vim.keymap.set("n", "<leader>oo", "<Cmd>Lspsaga outline<CR>", { desc = "Outline" })
end

-- ``打开当前cwd路径的终端
vim.keymap.set({ "n", "t" }, "``", "<Cmd>Lspsaga term_toggle<CR>", { desc = "Float Terminal" })
-- `<enter>打开当前文件路径的终端
vim.keymap.set({ "n", "t" }, "`<Enter>", function ()
  vim.api.nvim_command("Lspsaga term_toggle " .. os.getenv("SHELL") .. " " .. vim.fn.expand("%:p:h"))
end, { desc = "Float Terminal On Current Buffer Directory" })

return {
  setup_lsp_keymap = setup_lsp_keymap
}
