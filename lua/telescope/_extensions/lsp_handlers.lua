local my_utils = require("fengwk.utils")
local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values
local sorters = require "telescope.sorters"
local utils = require "telescope.utils"
local Path = require "plenary.path"

local lsp_util = vim.lsp.util
local lsp_buf = vim.lsp.buf

-- hack inject
local do_jump_to_location = lsp_util.jump_to_location
vim.lsp.util.jump_to_location = function(...)
  -- 跳转前增加jumplist标记
  -- :h m'
  vim.cmd "normal! m'"
  do_jump_to_location(...)
end

local setup_opts = {}

local mapping_actions = {
  ['<C-x>'] = actions.file_split,
  ['<C-v>'] = actions.file_vsplit,
  ['<C-t>'] = actions.file_tab,
}

local function jump_fn(prompt_bufnr, action, offset_encoding)
  return function()
    local selection = action_state.get_selected_entry(prompt_bufnr)
    if not selection or not selection.lnum or not selection.col then
      return
    end

    if action then
      action(prompt_bufnr)
    else
      actions.close(prompt_bufnr)
    end

    local pos = {
      line = selection.lnum - 1,
      character = selection.col,
    }

    -- process to uri if filename is not uri
    local uri = selection.filename
    if not my_utils.fs.is_uri(uri) then
      uri = vim.uri_from_fname(selection.filename)
    end

    lsp_util.jump_to_location({
      uri = uri,
      range = {
        start = pos,
        ['end'] = pos,
      },
    }, offset_encoding)
  end
end

local function attach_location_mappings(offset_encoding)
  return function(prompt_bufnr, map)
    local modes = { 'i', 'n' }
    local keys = { '<CR>', '<C-x>', '<C-v>', '<C-t>' }

    for _, mode in pairs(modes) do
      for _, key in pairs(keys) do
        local action = mapping_actions[key]
        map(mode, key, jump_fn(prompt_bufnr, action, offset_encoding))
      end
    end

    -- Additional mappings don't push the item to the tagstack.
    return true
  end
end

local function apply_edit_fn(prompt_bufnr, offset_encoding)
  return function()
    local selection = action_state.get_selected_entry(prompt_bufnr)
    actions.close(prompt_bufnr)
    if not selection then
      return
    end

    local action = selection.value
    if action.edit or type(action.command) == 'table' then
      if action.edit then
        lsp_util.apply_workspace_edit(action.edit, offset_encoding)
      end
      if type(action.command) == 'table' then
        lsp_buf.execute_command(action.command)
      end
    else
      lsp_buf.execute_command(action)
    end
  end
end

local function attach_code_action_mappings(offset_encoding)
  return function(prompt_bufnr, map)
    map('i', '<CR>', apply_edit_fn(prompt_bufnr, offset_encoding))
    map('n', '<CR>', apply_edit_fn(prompt_bufnr, offset_encoding))

    return true
  end
end

local function find(prompt_title, items, find_opts, offset_encoding)
  local opts = find_opts.opts or {}

  local entry_maker = find_opts.entry_maker or make_entry.gen_from_quickfix(opts)
  local sorter = find_opts.sorter or conf.generic_sorter(opts)
  local attach_mappings = find_opts.attach_mappings or attach_location_mappings(offset_encoding)
  local previewer = nil
  if not find_opts.hide_preview then
    previewer = conf.qflist_previewer(opts)
  end

  pickers
      .new(opts, {
        prompt_title = prompt_title,
        finder = finders.new_table({
          results = items,
          entry_maker = entry_maker,
        }),
        previewer = previewer,
        sorter = sorter,
        attach_mappings = attach_mappings,
      })
      :find()
end

local function get_correct_result(result1, result2)
  return type(result1) == 'table' and result1 or result2
end

local function location_handler(prompt_title, opts)
  -- Each lsp-handler has this signature: function(err, result, ctx, config)
  return function(_, result, context, _)
    local res = get_correct_result(result, context)
    local client = vim.lsp.get_client_by_id(context.client_id)

    if not res or vim.tbl_isempty(res) then
      print(opts.no_results_message)
      return
    end

    if not vim.tbl_islist(res) then
      lsp_util.jump_to_location(res, client.offset_encoding)
      return
    end

    if #res == 1 and res[1] then
      lsp_util.jump_to_location(res[1], client.offset_encoding)
      if res[1].uri then
        print("auto jump to " .. res[1].uri)
      end
      return
    end

    local items = lsp_util.locations_to_items(res, client.offset_encoding)
    local find_opts = opts["telescope_" .. client.name]
      and opts["telescope_" .. client.name]
      or opts.telescope
      or {}
    find(prompt_title, items, { opts = find_opts }, client.offset_encoding)
  end
end

local function symbol_handler(prompt_name, opts)
  opts = opts or {}

  -- Each lsp-handler has this signature: function(err, result, ctx, config)
  return function(_, result, context, _)
    local res = get_correct_result(result, context)
    if not res or vim.tbl_isempty(res) then
      print(opts.no_results_message)
      return
    end

    local items = lsp_util.symbols_to_items(res)
    local client = vim.lsp.get_client_by_id(context.client_id)
    find(prompt_name, items,
    {
      opts = opts["telescope_" .. client.name]
        and opts["telescope_" .. client.name]
        or opts.telescope
        or {},
      entry_maker = make_entry.gen_from_lsp_symbols(opts),
      sorter = conf.prefilter_sorter { tag = "symbol_type", sorter = conf.generic_sorter(opts), }
    }, client.offset_encoding)
  end
end

local function call_hierarchy_handler(prompt_name, direction, opts)
  -- Each lsp-handler has this signature: function(err, result, ctx, config)
  return function(_, result, context, _)
    local res = get_correct_result(result, context)
    if not res or vim.tbl_isempty(res) then
      print(opts.no_results_message)
      return
    end

    local items = {}
    for _, ch_call in pairs(res) do
      local ch_item = ch_call[direction]

      for _, range in pairs(ch_call.fromRanges) do
        table.insert(items, {
          filename = vim.uri_to_fname(ch_item.uri),
          text = ch_item.name,
          lnum = range.start.line + 1,
          col = range.start.character + 1,
        })
      end
    end
    local client = vim.lsp.get_client_by_id(context.client_id)
    find(prompt_name, items, { opts = opts["telescope_" .. client.name]
      and opts["telescope_" .. client.name]
      or opts.telescope
      or {} }, client.offset_encoding)
  end
end

local function code_action_handler(prompt_title, opts)
  -- Each lsp-handler has this signature: function(err, result, ctx, config)
  return function(_, result, context, _)
    local res = get_correct_result(result, context)
    if not res or vim.tbl_isempty(res) then
      print(opts.no_results_message)
      return
    end

    for idx, value in ipairs(res) do
      value.idx = idx
    end

    local client = vim.lsp.get_client_by_id(context.client_id)
    local find_opts = {
      opts = opts["telescope_" .. client.name]
        and opts["telescope_" .. client.name]
        or opts.telescope
        or {},
      entry_maker = function(line)
        return {
          valid = line ~= nil,
          value = line,
          ordinal = line.idx .. line.title,
          display = string.format('%s%d: %s', opts.prefix, line.idx, line.title),
        }
      end,
      attach_mappings = attach_code_action_mappings(client.offset_encoding),
      hide_preview = true,
    }
    find(prompt_title, res, find_opts, client.offset_encoding)
  end
end

-- 过滤一些不包含lsp方法的客户端
local lsp_blacklist = {
  "copilot",
}

local function select_client(bufnr)
  local candidates = vim.lsp.get_clients({ bufnr = bufnr })
  if candidates and #candidates > 0 then
    for _, candidate in ipairs(candidates) do
      if not vim.tbl_contains(lsp_blacklist, candidate.name) then
        return candidate
      end
    end
  end
  return nil
end

local _callable_obj = function()
  local obj = {}

  obj.__index = obj
  obj.__call = function(t, ...)
    return t:_find(...)
  end

  obj.close = function() end

  return obj
end

local WorkspaceSymbolDynamicFinder = _callable_obj()

function WorkspaceSymbolDynamicFinder:new(opts)
  opts = opts or {}

  assert(not opts.results, "`results` should be used with finder.new_table")
  assert(not opts.static, "`static` should be used with finder.new_oneshot_job")

  local obj = setmetatable({
    curr_buf = opts.curr_buf,
    fn = opts.fn,
    entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),
  }, self)

  return obj
end

function WorkspaceSymbolDynamicFinder:_find(prompt, process_result, process_complete)
  self.fn(prompt, function(results)
    for _, result in ipairs(results) do
      if process_result(self.entry_maker(result)) then
        return
      end
    end

    process_complete()
  end)
end

local function fzy_sorter(opts)
  opts = opts or {}
  local fzy = opts.fzy_mod or require "telescope.algos.fzy"
  local OFFSET = -fzy.get_score_floor()

  return sorters.Sorter:new {
    discard = true,

    scoring_function = function(_, prompt, line)
      -- 预处理prompt
      if opts.sort_prompt_pre_process then
        prompt = opts.sort_prompt_pre_process(prompt)
      end

      -- Check for actual matches before running the scoring alogrithm.
      if not fzy.has_match(prompt, line) then
        return -1
      end

      local fzy_score = fzy.score(prompt, line)

      -- The fzy score is -inf for empty queries and overlong strings.  Since
      -- this function converts all scores into the range (0, 1), we can
      -- convert these to 1 as a suitable "worst score" value.
      if fzy_score == fzy.get_score_min() then
        return 1
      end

      -- Poor non-empty matches can also have negative values. Offset the score
      -- so that all values are positive, then invert to match the
      -- telescope.Sorter "smaller is better" convention. Note that for exact
      -- matches, fzy returns +inf, which when inverted becomes 0.
      return 1 / (fzy_score + OFFSET)
    end,

    -- The fzy.positions function, which returns an array of string indices, is
    -- compatible with telescope's conventions. It's moderately wasteful to
    -- call call fzy.score(x,y) followed by fzy.positions(x,y): both call the
    -- fzy.compute function, which does all the work. But, this doesn't affect
    -- perceived performance.
    highlighter = function(_, prompt, display)
      return fzy.positions(prompt, display)
    end,
  }
end

local function get_workspace_symbols_requester(client, bufnr, opts)
  local latest_prompt = ""
  local cache = {}

  return function(prompt, complete_func)
    if opts.exclude_prompt and opts.exclude_prompt(prompt) then
      return
    end

    latest_prompt = prompt

    -- 尝试直接从缓存中获取
    if cache[prompt] then
      complete_func(cache[prompt])
    else
      -- hold住请求，延迟执行避免产生大量请求浪费lsp性能
      vim.defer_fn(function()
        -- 如果在请求期间没有发生prompt修改则继续
        if prompt == latest_prompt then
          if cache[prompt] then
            complete_func(cache[prompt])
          else
            -- 进行请求
            client.request("workspace/symbol", { query = prompt }, function (_, res)
              local locations = vim.lsp.util.symbols_to_items(res or {}, bufnr) or {}
              if not vim.tbl_isempty(locations) then
                locations = utils.filter_symbols(locations, opts) or {}
              end
              cache[prompt] = locations
              if prompt == latest_prompt then
                complete_func(locations)
              end
            end, bufnr)
          end
        end
      end, 200)
    end
  end
end

local function dynamic_workspace_symbols(opts)
  local client = select_client(vim.api.nvim_get_current_buf())
  if not client then
    print("dynamic_workspace_symbols: No LSP clients found")
    return
  end
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", opts,
    setup_opts.dynamic_workspace_symbols["telescope_" .. client.name]
    and setup_opts.dynamic_workspace_symbols["telescope_" .. client.name]
    or setup_opts.dynamic_workspace_symbols.telescope
    or {})
  opts.bufnr = opts.bufnr and opts.bufnr or vim.api.nvim_get_current_buf()

  pickers
    .new(opts, {
      prompt_title = "LSP Dynamic Workspace Symbols",
      finder = WorkspaceSymbolDynamicFinder:new {
        entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
        fn = get_workspace_symbols_requester(client, opts.bufnr, opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.prefilter_sorter { tag = "symbol_type", sorter = fzy_sorter(opts), },
      -- sorter = sorters.highlighter_only(opts),
      attach_mappings = attach_location_mappings(client.offset_encoding),
    })
    :find()
end

return telescope.register_extension({
  setup = function(opts)
    -- Use default options if needed.
    setup_opts = vim.tbl_deep_extend('keep', opts, {
      disable = {},
      location = {
        telescope = {},
        no_results_message = 'No references found',
      },
      symbol = {
        telescope = {},
        no_results_message = 'No symbols found',
      },
      call_hierarchy = {
        telescope = {},
        no_results_message = 'No calls found',
      },
      code_action = {
        telescope = {},
        no_results_message = 'No code actions available',
        prefix = '',
      },
      dynamic_workspace_symbols = {
        telescope = {},
      }
    })

    local handlers = {
      ['textDocument/declaration'] = location_handler('LSP Declarations', setup_opts.location),
      ['textDocument/definition'] = location_handler('LSP Definitions', setup_opts.location),
      ['textDocument/implementation'] = location_handler('LSP Implementations', setup_opts.location),
      ['textDocument/typeDefinition'] = location_handler('LSP Type Definitions', setup_opts.location),
      ['textDocument/references'] = location_handler('LSP References', setup_opts.location),
      ['textDocument/documentSymbol'] = symbol_handler('LSP Document Symbols', setup_opts.symbol),
      ['workspace/symbol'] = symbol_handler('LSP Workspace Symbols', setup_opts.symbol),
      ['callHierarchy/incomingCalls'] = call_hierarchy_handler('LSP Incoming Calls', 'from', setup_opts.call_hierarchy),
      ['callHierarchy/outgoingCalls'] = call_hierarchy_handler('LSP Outgoing Calls', 'to', setup_opts.call_hierarchy),
      ['textDocument/codeAction'] = code_action_handler('LSP Code Actions', setup_opts.code_action),
    }

    for req, handler in pairs(handlers) do
      if not setup_opts.disable[req] then
        vim.lsp.handlers[req] = handler
      end
    end
  end,
  exports = {
    dynamic_workspace_symbols = dynamic_workspace_symbols,
  },
})
