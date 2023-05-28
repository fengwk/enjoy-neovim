local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local make_entry = require('telescope.make_entry')

local base_opts = {}

local function select_client(bufnr)
  local candidates = vim.lsp.get_active_clients({ name = "jdtls", bufnr = bufnr })
  if candidates and #candidates > 0 then
    return candidates[1]
  end
  return nil
end

local function execute(client, method, params, bufnr)
  -- lsp-handler
  local co = coroutine.running()
  assert(co, "no running coroutine")
  client.request(method, params, function(err, result, ctx, config)
    coroutine.resume(co, err, result, ctx, config)
  end, bufnr)
  return coroutine.yield()
end

local function make_pos(uri)
  if not uri then
    uri = vim.lsp.util.make_position_params(0).textDocument.uri
  end
  return {
    position = {
      character = 0,
      line = 1
    },
    textDocument = {
      uri = uri
    }
  }
end

local function parent_type_hierarchy(client, bufnr, uri)
  local params = {
    command = 'java.navigate.openTypeHierarchy',
    arguments = { vim.fn.json_encode(make_pos(uri)), "1", "1" }
  }
  local _, resp = execute(client, "workspace/executeCommand", params, bufnr)
  return resp
end

local function collect_types(types, client, bufnr, uri)
  local resp = parent_type_hierarchy(client, bufnr, uri)
  if resp then
    table.insert(types, resp.uri);
    if resp.parents and #resp.parents > 0 then
      for _, p in ipairs(resp.parents) do
        collect_types(types, client, bufnr, p.uri)
      end
    end
  end
end

local function collect_symbols(inherited_members, flags, client, bufnr, uri)
  local pos = make_pos(uri)
  local filename = vim.uri_to_fname(pos.textDocument.uri)
  local _, resp = execute(client, "textDocument/documentSymbol", pos, bufnr)
  local items = vim.lsp.util.symbols_to_items(resp)
  if resp and #resp > 0 then
    for _, item in ipairs(items) do
      item.filename = filename
      local text = item.text
      if not flags[text] then
        table.insert(inherited_members, item)
        flags[text] = true
      end
    end
  end
end

local function jump_location(offset_encoding)
  local selection = action_state.get_selected_entry()
  local uri = selection.filename
  if not string.match(uri, "^[^:]+://") then
    uri = vim.uri_from_fname(uri)
  end
  local pos = {
    line = selection.lnum - 1,
    character = selection.col,
  }
  vim.lsp.util.jump_to_location({
    uri = uri,
    range = {
      start = pos,
      ['end'] = pos,
    }}, offset_encoding)
end

local function inherited_members(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("keep", {
    path_display = "hidden" -- 隐藏文件路径显示
  }, opts)
  local bufnr = opts.bufnr
  local client = select_client(bufnr)
  if not client then
    return
  end

  coroutine.wrap(function()
    -- 收集数据
    local types = {}
    collect_types(types, client, bufnr, nil)
    local inherited_members = {}
    local flags = {}
    for _, turi in ipairs(types) do
      collect_symbols(inherited_members, flags, client, bufnr, turi)
    end

    -- telescope
    pickers.new(opts, {
      prompt_title = "Inherited Members",
      finder = finders.new_table {
        results = inherited_members,
        entry_maker = make_entry.gen_from_lsp_symbols(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.prefilter_sorter {
        tag = "symbol_type",
        sorter = conf.generic_sorter(opts),
      },
      attach_mappings = function(_, map)
        map({ "n", "i" }, "<CR>", function(prompt_bufnr)
          actions.close(prompt_bufnr)
          jump_location(client.offset_encoding)
        end)
        map({ "n", "i" }, "<C-x>", function(prompt_bufnr)
          actions.file_split(prompt_bufnr)
          jump_location(client.offset_encoding)
        end)
        map({ "n", "i" }, "<C-v>", function(prompt_bufnr)
          actions.file_vsplit(prompt_bufnr)
          jump_location(client.offset_encoding)
        end)
        map({ "n", "i" }, "<C-t>", function(prompt_bufnr)
          actions.file_tab(prompt_bufnr)
          jump_location(client.offset_encoding)
        end)
        return true
      end
    }):find()
  end)()
end

return require("telescope").register_extension({
  -- setup = function(opts)
  --   base_opts = opts or {}
  -- end,
  exports = {
    inherited_members = inherited_members,
  },
})