local ok, _ = pcall(require, "jdtls")
if not ok then
  return
end

local ext_common = require("telescope._extensions.common")
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local make_entry = require('telescope.make_entry')

local base_opts = {}

local function enhance_pick_one(fallback)
  return function(items, prompt, label_fn)
    local co = coroutine.running()
    -- 如果当前不在协程环境中使用降级方式进行选择
    if not co then
      return fallback(items, prompt, label_fn)
    end

    -- 使用telescope进行选择
    local choices = {}
    local choice_to_item = {}
    label_fn = label_fn and label_fn or function(item) return item end
    for i, item in ipairs(items) do
      local choice = string.format('%d: %s', i, label_fn(item))
      table.insert(choices, choice)
      choice_to_item[choice] = item
    end

    local opts = vim.tbl_deep_extend("keep", base_opts, { bufnr = vim.api.nvim_get_current_buf() })

    pickers.new(opts, {
      prompt_title = prompt,
      finder = finders.new_table { results = choices },
      attach_mappings = function(_, map)
        ext_common.map_select_one(map, function(prompt_bufnr)
          local picker = action_state.get_current_picker(prompt_bufnr)
          local selection = picker:get_selection()
          local selected = selection and selection[1] and choice_to_item[selection[1]] or nil
          actions.close(prompt_bufnr)
          coroutine.resume(co, selected)
        end)
        map({ "n", "i" }, "<C-c>", function(prompt_bufnr)
          actions.close(prompt_bufnr)
          coroutine.resume(co, nil)
        end)
        map({ "n", "i" }, "<C-q>", function(prompt_bufnr)
          actions.close(prompt_bufnr)
          coroutine.resume(co, nil)
        end)
        -- 不使用默认绑定
        return false
      end,
      sorter = conf.generic_sorter(opts),
    }):find()
    return coroutine.yield()
  end
end

local function enhance_pick_many(fallback)
  return function(items, prompt, label_fn)
    local co = coroutine.running()
    -- 如果当前不在协程环境中使用降级方式进行选择
    if not co then
      return fallback(items, prompt, label_fn)
    end

    -- 使用telescope进行选择
    local choices = {}
    local choice_to_item = {}
    label_fn = label_fn and label_fn or function(item) return item end
    for i, item in ipairs(items) do
      local choice = string.format('%d: %s', i, label_fn(item))
      table.insert(choices, choice)
      choice_to_item[choice] = item
    end

    local opts = vim.tbl_deep_extend("keep", base_opts, { bufnr = vim.api.nvim_get_current_buf() })

    pickers.new(opts, {
      prompt_title = prompt,
      finder = finders.new_table { results = choices },
      attach_mappings = function(_, map)
        ext_common.map_select_many(map, function(prompt_bufnr)
          local picker = action_state.get_current_picker(prompt_bufnr)
          local multi_selection = picker:get_multi_selection()
          local selecteds = {}
          for _, selection in ipairs(multi_selection) do
            local selected = selection and selection[1] and choice_to_item[selection[1]] or nil
            if selected then
              table.insert(selecteds, selected)
            end
          end
          actions.close(prompt_bufnr)
          coroutine.resume(co, selecteds)
        end)
        map({ "n", "i" }, "<C-c>", function(prompt_bufnr)
          actions.close(prompt_bufnr)
          coroutine.resume(co, nil)
        end)
        map({ "n", "i" }, "<C-q>", function(prompt_bufnr)
          actions.close(prompt_bufnr)
          coroutine.resume(co, nil)
        end)
        -- 不使用默认绑定
        return false
      end,
      sorter = conf.generic_sorter(opts),
    }):find()
    return coroutine.yield()
  end
end

local function setup_ui()
  local jdtls_ui = require("jdtls.ui")
  jdtls_ui.pick_one = enhance_pick_one(jdtls_ui.pick_one)
  jdtls_ui.pick_many = enhance_pick_many(jdtls_ui.pick_many)
end

-- local enable_auto_organize_imports = false
-- local function setup_auto_organize_imports()
--   local jdtls = require("jdtls")
--   local command = "java.action.organizeImports.chooseImports"
--   -- 存在问题，如果没有需要选择则无法清理当次的enable_auto_organize_imports
--   local origin_java_choose_imports = jdtls.commands[command]
--   local java_choose_imports = function(...)
--     if enable_auto_organize_imports then
--       enable_auto_organize_imports = false
--       return {}
--     end
--     return origin_java_choose_imports(...)
--   end
--   jdtls.commands[command] = java_choose_imports
--   vim.lsp.commands[command] = java_choose_imports
-- end

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
      line = 0
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
    }
  }, offset_encoding)
end

local function inherited_members(opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, base_opts, {
    path_display = "hidden", -- 隐藏文件路径显示
    bufnr = vim.api.nvim_get_current_buf(),
  })
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
  setup = function(opts)
    if opts and #opts >= 1 then
      base_opts = opts[1]
    end
    setup_ui()
    -- setup_auto_organize_imports()
  end,
  exports = {
    inherited_members = inherited_members,
  },
})
