require "user.ide.nvim-dap-ui"
require "user.ide.nvim-dap-virtual-text"
require "user.ide.nvim-dap"
require "user.ide.dap-cpp"
require "user.ide.dap-go"
require "user.ide.dap-nodejs"
require "user.ide.dap-python"
-- https://github.com/neovim/nvim-lspconfig
local lspconfig = require "lspconfig"
-- https://github.com/williamboman/mason.nvim
local mason = require "mason"
-- https://github.com/williamboman/mason-lspconfig.nvim
local mason_lspconfig = require "mason-lspconfig"
-- https://github.com/jose-elias-alvarez/null-ls.nvim
-- local null_ls = require "null-ls"

local utils = require "user.utils"
local lsp_utils = require "user.ide.lsp-utils"

-- LSP table，存储内容是string|table entry
-- string LSP名称
-- table entry key是LSP名称，value是相应
local lsp_tab = utils.table_filter({
  "bashls",                                               -- { "sh" }
  "clangd",                                               -- { "c", "cpp", "objc", "objcpp", "cuda", "proto" }
  "cssls",                                                -- { "css", "scss", "less" }
  "gopls",                                                -- { "go", "gomod", "gowork", "gotmpl" }
  "groovyls",                                             -- { "groovy" }
  "html",                                                 -- { "html" }
  "jsonls",                                               -- { "json", "jsonc" }
  [ "sumneko_lua" ] = require "user.ide.lsp-sumneko_lua", -- { "lua" }
  utils.os_name == "win" and "powershell_es" or nil,      -- { "ps1" }
  "pyright",                                              -- { "python" }
  "sqls",                                                 -- { "sql", "mysql" }
  "tsserver",                                             -- { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  "vimls",                                                -- { "vim" }
  "yamlls",                                               -- { "yaml", "yaml.docker-compose" }
}, utils.non_nil)

-- 安装LSP
local function setup_lsp(lsp, conf)
  if conf == nil then
    conf = {}
  end
  if conf.on_attach == nil then
    conf.on_attach = function(client, bufnr)
      lsp_utils.on_attach(client, bufnr)
    end
  end
  if conf.capabilities == nil then
    conf.capabilities = lsp_utils.make_capabilities()
  end
  lspconfig[lsp].setup(conf)
end

-- 安装LSP列表
local function setup_lsp_list(tab)
  for k, v in pairs(tab) do
    local lsp, conf
    if type(k) == 'string' then
      -- table entry
      lsp = k
      conf = v
    else
      -- string
      lsp = v
      conf = nil
    end
    -- 安装
    setup_lsp(lsp, conf)
  end
end

-- 进行LSP列表安装
setup_lsp_list(lsp_tab)

-- 安装null-ls
-- null_ls.setup({
--   sources = {
--     -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting/prettier.lua
--     null_ls.builtins.formatting.prettier.with({
--         filetypes = {
--           -- "javascript",
--           -- "javascriptreact",
--           -- "typescript",
--           -- "typescriptreact",
--           -- "vue",
--           "css",
--           "scss",
--           "less",
--           "html",
--           "json",
--           "jsonc",
--           "yaml",
--           "markdown",
--           "markdown.mdx",
--           "graphql",
--           -- "handlebars",
--         },
--     }),
--   },
-- })

-- 从lsp_tab中提取lsp_list
local function extract_lsp_list(tab)
  local lsp_list = {}
  for k, v in pairs(tab) do
    if type(k) == 'string' then
      -- table entry
      table.insert(lsp_list, k)
    else
      -- string
      table.insert(lsp_list, v)
    end
  end
  return lsp_list
end

local dap_list = {
  "debugpy",
  "delve",
  "cpptools",
  "node-debug2-adapter",
}

-- 组装必要安装的包
local ensure_installed = extract_lsp_list(lsp_tab)
ensure_installed = utils.list_merge(ensure_installed, dap_list)
table.insert(ensure_installed, "jdtls") -- jdtls不使用lspconfig方式启动，因此需要额外添加
-- table.insert(ensure_installed, "prettier") -- null-ls formatter

-- 安装mason
mason.setup()
-- 安装必要的LSP服务
mason_lspconfig.setup {
  ensure_installed = ensure_installed,
  -- 自动安装所有通过lspconfig setup的服务器，与ensure_installed参数无关
  automatic_installation = false,
}

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, keymapopts)
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, keymapopts)
-- 在诊断信息之间跳转
vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Diagnostic Prev" })
vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Diagnostic Next" })
-- 使用telescope搜索诊断信息
-- vim.keymap.set("n", "ge", "<Cmd>lua require('telescope.builtin').diagnostics()<CR>", { noremap = true, silent = true, desc = "Lsp Diagnostics" })
-- 打开带有所有诊断信息的quickfix
vim.keymap.set("n", "ge", vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Diagnostic Quickfix" })