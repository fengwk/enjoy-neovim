-- https://github.com/neovim/nvim-lspconfig
local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
if not ok_lspconfig then
  return
end

require('lspconfig.ui.windows').default_options.border = vim.g.__border

-- Levels by name: "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"
vim.lsp.set_log_level("WARN")

local utils = require("fengwk.utils")

-- 将cwd设置为lsp根目录
local function cd_lsp_root(opts, client, buffer, auto_add_ws)
  local root = opts.root
  local single_file = opts.single_file
  if not root and client.workspace_folders and #client.workspace_folders > 0 then
    root = client.workspace_folders[1].name
    single_file = not root or not utils.fs.is_dir(root)
    if not utils.fs.is_dir(root) then
      root = utils.fs.parent(root)
    end
  end
  if root then
    -- cd
    utils.vim.cd(root, vim.api.nvim_buf_get_name(buffer))

    -- 如非单文件服务则自动添加workspace
    if auto_add_ws and not single_file then
      local ws_ok, ws = pcall(require, "fengwk.plugins.workspaces.workspaces")
      if ws_ok then
        ws.add(root, true)
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

-- 设置hover边框
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = vim.g.__border,
  }
)

-- 设置lsp关闭钩子
vim.api.nvim_create_augroup("lsp_destruction", { clear = true })
vim.api.nvim_create_autocmd(
  { "BufDelete" },
  { group = "lsp_destruction", callback = function(args)
    if args and args.buf and args.buf > 0 then
      local clients = vim.lsp.get_active_clients()
      for _, c in pairs(clients) do
        if c and c.id and c.name ~= "copilot" then
          local lsp_bufs = vim.lsp.get_buffers_by_client_id(c.id)
          if not lsp_bufs or #lsp_bufs == 0
            or (#lsp_bufs == 1 and lsp_bufs[1] == args.buf) then
            vim.lsp.stop_client(c.id)
            vim.notify("lsp client " .. c.name .. "[" .. c.id .. "]" .. " auto closed")
          end
        end
      end
    end
  end}
)

local function root_and_single_file()
  local root = vim.lsp.buf.list_workspace_folders()
  local is_single_file = false
  if root ~= nil and #root > 0 then
    local rp = root[1]
    if utils.fs.is_dir(rp) then
      root = rp
    else
      root = utils.fs.parent(rp)
      is_single_file = true
    end
  end
  return root, is_single_file
end

local function build_on_attach(opts)
  opts = opts or {}
  -- 默认的lsp on_attach
  return function(client, bufnr)
    -- dap
    require("fengwk.plugins.lsp.nvim-dap").setup_keymap(bufnr)

    -- lsp
    local keymap = vim.keymap

    keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Add Workspace Folder" })
    keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Remove Workspace Folder" })
    keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { silent = true, buffer = bufnr, desc = "Lsp List Workspace Folder" })

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Signature Help" })
    keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Hover" })
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Rename" })
    keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Code Action" })
    keymap.set("v", "<leader>ca", function ()
      local range = get_range();
      vim.api.nvim_input("<Esc>")
      vim.lsp.buf.code_action(range)
    end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Range Code Action" })

    if client.name ~= "jsonls" then -- json使用自定义的格式化方式
      keymap.set("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Formatting" })
      keymap.set("v", "<leader>fm", function ()
        local range = get_range();
        vim.api.nvim_input("<Esc>")
        vim.lsp.buf.format({
          range = range,
          async = true
        })
      end, { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Range Formatting" })
    end

    keymap.set("n", "gs", "<Cmd>Telescope lsp_document_symbols<CR>", { silent = true, buffer = bufnr, desc = "Lsp Document Symbols" })
    keymap.set("n", "gw", "<Cmd>Telescope lsp_handlers dynamic_workspace_symbols<CR>", { buffer = bufnr, desc = "Lsp Workspace Symbol" })
    keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Lsp References" })
    keymap.set("n", "g<leader>", vim.lsp.buf.implementation, { silent = true, buffer = bufnr, desc = "Lsp Implementation" })
    keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, buffer = bufnr, desc = "Lsp Definition" })
    keymap.set("n", "gD", vim.lsp.buf.declaration, { silent = true, buffer = bufnr, desc = "Lsp Declaration" })
    keymap.set("n", "gt", vim.lsp.buf.type_definition, { silent = true, buffer = bufnr, desc = "Lsp Type Definition" })
    keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "Lsp Workspace Symbols" })
    keymap.set("n", "<leader>gi", "<Cmd>Lspsaga incoming_calls<CR>", { silent = true, buffer = bufnr, desc = "Lsp Incoming Calls" })
    keymap.set("n", "<leader>go", "<Cmd>Lspsaga outgoing_calls<CR>", { silent = true, buffer = bufnr, desc = "Lsp Outgoing Calls" })

    -- outline
    keymap.set("n", "<leader>oo", "<Cmd>Lspsaga outline<CR>", { desc = "Outline" })

    -- 在attatch成功后改变vim的cwd，并且注册跳转
    if client.name ~= "copilot" then
      cd_lsp_root(opts, client, bufnr, vim.tbl_contains(auto_add_ws_clients, client.name))
    end

    -- 去除newline自动生成注释前缀
    -- vim.cmd("set formatoptions-=cro")
  end
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
  ["clangd"] = require("fengwk.plugins.lsp.lsp-clangd"),      -- { "c", "cpp", "objc", "objcpp", "cuda", "proto" }
  "cssls",                                                    -- { "css", "scss", "less" }
  ["gopls"] = require("fengwk.plugins.lsp.lsp-gopls"),        -- { "go", "gomod", "gowork", "gotmpl" }
  "groovyls",                                                 -- { "groovy" }
  "html",                                                     -- { "html" }
  ["lua_ls"] = require("fengwk.plugins.lsp.lsp-lua_ls"),      -- { "lua" }
  utils.sys.os == "win" and "powershell_es" or nil,           -- { "ps1" }
  "pylsp",                                                    -- { "python" }
  ["tsserver"] = require("fengwk.plugins.lsp.lsp-tsserver"),  -- { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  "vimls",                                                    -- { "vim" }
  "yamlls",                                                   -- { "yaml", "yaml.docker-compose" }
  -- "lemminx",                                                  -- { "xml", "xsd", "xsl", "xslt", "svg" }
  "dockerls",                                                 -- { "dockerfile" }
  ["jsonls"] = require("fengwk.plugins.lsp.lsp-jsonls"),      -- { "json", "jsonc" }
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
    conf.on_attach = build_on_attach()
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
  build_on_attach = build_on_attach,
  make_capabilities = make_capabilities,
}
