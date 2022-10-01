-- 默认的lsp on_attach
local function on_attach(client, bufnr)

  -- lsp-status
  -- require("lsp-status").on_attach(client)

  -- 使用cmp-nvim-lsp代替omnifunc
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- vim.keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Signature Help" })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Hover" })
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Add Workspace Folder" })
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Remove Workspace Folder" })
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp List Workspace Folder" })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Rename" })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Code Action" })
  vim.keymap.set("n", "<leader>fm", vim.lsp.buf.formatting, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Formatting" })

  -- 区间处理必须先<Esc>推出可视模式，只有这样下面两个方法才能获取到可视模式的区间
  -- print(vim.inspect(vim.api.nvim_buf_get_mark(0, '<')))
  -- print(vim.inspect(vim.api.nvim_buf_get_mark(0, '>')))
  -- 获取当前缓冲区
  -- local bufnr = vim.fn.bufnr()
  -- 另一种无需<Esc>的方法见issus：https://github.com/neovim/neovim/pull/13896#issuecomment-774680224
  -- local start_pos = vim.fn.getpos("v")
  -- local end_pos = vim.fn.getcurpos()
  vim.keymap.set("v", "<leader>ca", "<Esc><Cmd>lua vim.lsp.buf.range_code_action()<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Range Code Action" })
  vim.keymap.set("v", "<leader>fm", "<Esc><Cmd>lua vim.lsp.buf.range_formatting()<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Range Formatting" })

  -- local function telescope_builtin_lsp_references()
  --   require("telescope.builtin").lsp_references({
  --     show_line = false,
  --     -- trim_text = true,
  --   })
  -- end
  --
  -- local function telescope_builtin_lsp_workspace_symbols()
  --   local q = vim.fn.input("Query: ")
  --   require("telescope.builtin").lsp_workspace_symbols({
  --     query = q,
  --   })
  -- end
  --
  -- -- telescope
  -- vim.keymap.set("n", "gr", telescope_builtin_lsp_references, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp References" })
  -- vim.keymap.set("n", "gs", "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Document Symbols" })
  -- vim.keymap.set("n", "gS", telescope_builtin_lsp_workspace_symbols, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Workspace Symbols" })
  -- vim.keymap.set("n", "gj", "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Implementation" })
  -- vim.keymap.set("n", "gd", "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Definition" })
  -- vim.keymap.set("n", "gt", "<Cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Type Definition" })

  -- local function lsp_workspace_symbols()
  --   local q = vim.fn.input("Query: ")
  --   if not string.match(q, "^*") then
  --     q = "*" .. q
  --   end
  --   if not string.match(q, "*$") then
  --     q = q .. "*"
  --   end
  --   vim.lsp.buf.workspace_symbol(q);
  -- end

  -- lsp native
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp References" })
  vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Document Symbol" })
  vim.keymap.set("n", "gS", vim.lsp.buf.workspace_symbol, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Workspace Symbol" })
  vim.keymap.set("n", "gj", vim.lsp.buf.implementation, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Implementation" })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Declaration" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Definition" })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp References" })

  -- 在attatch成功后改变vim的cwd
  local rootdir = vim.lsp.buf.list_workspace_folders()
  if rootdir ~= nil and #rootdir > 0 then
    vim.api.nvim_command("cd " .. rootdir[1])
  end

  -- 代码高亮，CursorHold依赖于:h updatetime，通过设置及时的updatetime可以提升高亮的相应速度
  -- 使用RRethy/vim-illuminate替代
  -- vim.api.nvim_exec([[
  --   augroup lsp_document_highlight
  --     autocmd!
  --     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --   augroup end
  -- ]], false)
end

-- 为lsp补全提供支持
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
local function make_capabilities ()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
  return capabilities
end

return {
  on_attach = on_attach,
  make_capabilities = make_capabilities,
}