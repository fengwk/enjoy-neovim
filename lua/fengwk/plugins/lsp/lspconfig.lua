-- https://github.com/neovim/nvim-lspconfig
local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
if not ok_lspconfig then
  return
end

local Path = require("plenary.path")
local utils = require("fengwk.utils")

-- 将cwd设置为lsp根目录
local function cd_lsp_root(auto_add_ws)
  local root = vim.lsp.buf.list_workspace_folders()
  local is_single_file = false
  if root ~= nil and #root > 0 then
    local root_path = Path:new(root[1])
    if root_path:is_dir() then
      root = root[1]
    else
      root = root_path:parent():expand()
      is_single_file = true
    end
    vim.api.nvim_command("cd " .. root) -- 切换根目录

    local t_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
    if t_ok then
      nvim_tree_api.tree.change_root(root) -- 主动修改nvim-tree root，否则切换会出现问题
    end

    -- 如非单文件服务则自动添加workspace
    if auto_add_ws and not is_single_file then
      local ws_ok, ws = pcall(require, "workspaces")
      if ws_ok then
        local ws_name = vim.fn.fnamemodify(root, ":t")
        local exists_ws_name = false
        local ws_list = ws.get()
        if ws_list ~= nil then
          for _, item in pairs(ws_list) do
            if ws_name == item.name then
              exists_ws_name = true
            end
          end
        end
        if not exists_ws_name then
          ws.add(root)
        end
      end
    end
  end
end

local auto_add_ws_clients = {
  "clangd", "gopls", "groovy", "lua_ls", "jedi_language_server", "tsserver", "jdtls"
}

local function get_range()
  local bufnr = vim.api.nvim_get_current_buf()
  return {
    start = vim.api.nvim_buf_get_mark(bufnr, '<'),
    ["end"] = vim.api.nvim_buf_get_mark(bufnr, '>'),
  }
end

-- 默认的lsp on_attach
local function on_attach(client, bufnr)

  local keymap = vim.keymap

  keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Add Workspace Folder" })
  keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Remove Workspace Folder" })
  keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp List Workspace Folder" })

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Signature Help" })
  keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Hover" })
  keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Rename" })
  keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Code Action" })
  keymap.set("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Formatting" })
  keymap.set("v", "<leader>ca", function ()
    local range = get_range();
    vim.api.nvim_input("<Esc>")
    vim.lsp.buf.code_action(range)
  end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Range Code Action" })
  keymap.set("v", "<leader>fm", function ()
    local range = get_range();
    vim.api.nvim_input("<Esc>")
    vim.lsp.buf.format({
      range = range,
      async = true
    })
  end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Range Formatting" })

  local function telescope_builtin_lsp_references()
    require("telescope.builtin").lsp_references({
      show_line = false,
      -- trim_text = true,
    })
  end

  local function telescope_builtin_lsp_workspace_symbols()
    local q = vim.fn.input("Query: ")
    require("telescope.builtin").lsp_workspace_symbols({
      query = q,
    })
  end

  -- telescope
  -- keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Document Symbol" })
  keymap.set("n", "gr", telescope_builtin_lsp_references, { buffer = bufnr, desc = "Lsp References" })
  -- keymap.set("n", "gs", function() vim.lsp.buf.document_symbol({}) end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Document Symbol" })
  -- keymap.set("n", "gs", "<Cmd>Telescope aerial theme=dropdown<CR>", { silent = true, buffer = bufnr, desc = "Lsp Document Symbols" })
  keymap.set("n", "gs", "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", { silent = true, buffer = bufnr, desc = "Lsp Document Symbols" })
  keymap.set("n", "g<leader>", "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", { silent = true, buffer = bufnr, desc = "Lsp Implementation" })
  keymap.set("n", "gd", "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>", { silent = true, buffer = bufnr, desc = "Lsp Definition" })
  -- keymap.set("n", "gd", vim.lsp.buf.declaration, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Document Symbol" })
  keymap.set("n", "gt", "<Cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", { silent = true, buffer = bufnr, desc = "Lsp Type Definition" })
  keymap.set("n", "gw", telescope_builtin_lsp_workspace_symbols, { buffer = bufnr, desc = "Lsp Workspace Symbols" })
  keymap.set("n", "gW",  "<Cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>", { silent = true, buffer = bufnr, desc = "Lsp Workspace Symbol" })
  keymap.set("n", "<leader>gi", "<Cmd>lua require('telescope.builtin').lsp_incoming_calls()<CR>", { silent = true, buffer = bufnr, desc = "Lsp Incoming Calls" })
  keymap.set("n", "<leader>go", "<Cmd>lua require('telescope.builtin').lsp_outgoing_calls()<CR>", { silent = true, buffer = bufnr, desc = "Lsp Outgoing Calls" })

  -- 在attatch成功后改变vim的cwd，并且注册跳转
  cd_lsp_root(vim.tbl_contains(auto_add_ws_clients, client.name))
  -- 在workspace增强逻辑中完成cwd自动切换
  -- vim.api.nvim_create_autocmd({ "BufEnter" }, { buffer = bufnr, callback = cd_lsp_root })
end

-- 添加补全能力支持
local function make_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

-- lsp配置表
local lsp_configs = {
  "bashls",                                                   -- { "sh" }
  "clangd",                                                   -- { "c", "cpp", "objc", "objcpp", "cuda", "proto" }
  "cssls",                                                    -- { "css", "scss", "less" }
  ["gopls"] = require("fengwk.plugins.lsp.lsp-gopls"),        -- { "go", "gomod", "gowork", "gotmpl" }
  "groovyls",                                                 -- { "groovy" }
  "html",                                                     -- { "html" }
  ["lua_ls"] = require("fengwk.plugins.lsp.lsp-sumneko_lua"), -- { "lua" }
  utils.os_name == "win" and "powershell_es" or nil,          -- { "ps1" }
  "pylsp",                                                    -- { "python" }
  ["tsserver"] = require("fengwk.plugins.lsp.lsp-tsserver"),  -- { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  "vimls",                                                    -- { "vim" }
  "yamlls",                                                   -- { "yaml", "yaml.docker-compose" }
  -- "lemminx",                                                  -- { "xml", "xsd", "xsl", "xslt", "svg" }
  "dockerls",                                                 -- { "dockerfile" }
}

-- 使用mason安装lsp服务
local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if ok_mason_lspconfig then
  local lsp_servers = { "jdtls" }
  for k, v in pairs(lsp_configs) do
    local lsp
    if type(k) == "string" then -- table entry
      lsp = k
    else
      lsp = v -- string
    end
    if lsp then
      table.insert(lsp_servers, lsp)
    end
  end
  mason_lspconfig.setup({ ensure_installed = lsp_servers, automatic_installation = true })
end

local function setup_lsp(lsp, conf)
  if conf == nil then
    conf = {}
  end
  if conf.on_attach == nil then
    conf.on_attach = on_attach
  end
  if conf.capabilities == nil then
    conf.capabilities = make_capabilities()
  end
  lspconfig[lsp].setup(conf)
end

-- 安装所有lsp配置
for k, v in pairs(lsp_configs) do
  local lsp, conf
  if type(k) == "string" then -- table entry
    lsp = k
    conf = v
  else -- string
    lsp = v
    conf = nil
  end
  -- 安装
  if lsp then
    setup_lsp(lsp, conf)
  end
end

-- 在诊断信息之间跳转
vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { silent = true, desc = "Diagnostic Prev" })
vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { silent = true, desc = "Diagnostic Next" })
-- 使用telescope搜索诊断信息
vim.keymap.set("n", "[E", "<Cmd>lua require('telescope.builtin').diagnostics()<CR>", { silent = true, desc = "Telescope Diagnostics" })
vim.keymap.set("n", "]E", "<Cmd>lua require('telescope.builtin').diagnostics()<CR>", { silent = true, desc = "Telescope Diagnostics" })
-- 打开带有所有诊断信息的quickfix
-- vim.keymap.set("n", "ge", vim.diagnostic.setloclist, { silent = true, desc = "Diagnostic Quickfix" })

return {
  on_attach = on_attach,
  make_capabilities = make_capabilities,
}