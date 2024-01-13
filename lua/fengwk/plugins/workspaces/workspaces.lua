local utils = require("fengwk.utils")

local data_path = utils.fs.stdpath("data", "workspaces.json")

local ws = {}

local data_cache = nil
local data_cache_pre_read = 0
local data_cache_read_timeout = 1e6 * 500 -- 500毫秒，配置读取超时

local cur_ws = nil                        -- 当前缓冲区

-- 从from开始找到任一最近的workspce执行do_func
local function find_ws_and_do(do_func, from)
  if not do_func or utils.lang.str_empty(from) then
    return
  end
  local data = ws.read_data()
  if not data then
    return
  end
  utils.fs.iter_path_to_root(from, function(cur_path)
    if data[cur_path] then
      do_func(cur_path, from)
      return false
    end
    return true
  end)
end

-- 统一workspace name，可以避免处理/a和/a/存在两个工作空间的问题
local function regularize_ws_name(ws_name)
  if ws_name then
    ws_name = vim.fn.expand(ws_name)
    if ws_name and #ws_name > 0 and ws_name:sub(-1) == utils.fs.sp then
      ws_name = ws_name:sub(1, -2)
    end
  end
  return ws_name
end

ws.write_data = function(data)
  data_cache = data
  utils.fs.write_data(data_path, data_cache)
end

ws.read_data = function()
  local cur_nanos = vim.loop.hrtime()
  if cur_nanos < data_cache_pre_read + data_cache_read_timeout and data_cache then
    return data_cache
  end
  data_cache = utils.fs.read_data(data_path)
  data_cache_pre_read = cur_nanos
  return data_cache
end

-- 添加一个工作空间
ws.add = function(ws_name, ignore_exists)
  ws_name = ws_name or vim.fn.getcwd()
  ws_name = regularize_ws_name(ws_name)
  if not utils.fs.is_dir(ws_name) then
    vim.notify(ws_name .. " is not dir")
    return
  end
  local data = ws.read_data()
  if data and data[ws_name] then
    if not ignore_exists then
      vim.notify(ws_name .. " already exists")
    end
    return
  end
  if not data then
    data = {}
  end
  data[ws_name] = {}
  local filename = vim.fn.expand("%:p")
  if filename and filename ~= "" then
    data[ws_name].filename = filename
  end
  vim.notify(ws_name .. " has been added to workspaces")
  ws.write_data(data)
end

-- 移除一个工作空间
ws.remove = function(ws_name)
  ws_name = ws_name or vim.fn.getcwd()
  ws_name = regularize_ws_name(ws_name)
  local data = ws.read_data()
  if not data or not data[ws_name] then
    vim.notify(ws_name .. " cannot found")
    return
  end
  local new_data = {}
  for k, v in pairs(data) do
    if k ~= ws_name then
      new_data[k] = v
    end
  end
  ws.write_data(new_data)
  vim.notify(ws_name .. " has been removed from workspaces")
end

-- 列出所有工作空间
ws.list = function()
  local data = ws.read_data()
  local ws_list = {}
  if data then
    for k, _ in pairs(data) do
      table.insert(ws_list, k)
    end
  end
  return ws_list
end

-- 记录当前缓冲区对应的文件
ws.record_file = function(ws_name, filename)
  if not ws_name or not filename then
    return
  end
  ws_name = regularize_ws_name(ws_name)
  local data = ws.read_data()
  if not data or not data[ws_name] then
    return
  end
  if not filename or utils.fs.is_uri(filename) then
    return
  end
  utils.fs.iter_path_to_root(filename, function(cur_path)
    if cur_path == ws_name then
      local ws_data = data[ws_name]
      ws_data.filename = filename
      ws.write_data(data)
      return false
    end
    return true
  end)
end

-- 获取当前工作空间名称
ws.current_ws_name = function()
  local from = vim.fn.expand("%:p")
  if utils.lang.str_empty(from) then
    from = vim.fn.getcwd()
  end
  local wn = nil
  find_ws_and_do(function(ws_name, _)
    wn = ws_name
  end, from)
  return wn
end

-- 关闭指定工作空间
ws.close = function(ws_name)
  if not ws_name then
    return
  end
  vim.schedule(function()
    local full_closed = true
    local match_ws_name = ws_name .. '/';
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(bufnr) and not utils.vim.is_sepcial_ft(bufnr) then
        local filename = vim.api.nvim_buf_get_name(bufnr)
        if filename then
          local idx = utils.lang.str_index(filename, match_ws_name)
          if idx == 1 then
            -- 如果缓冲区没有未修改内容则进行关闭
            local ok = pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
            if not ok then
              full_closed = false
            end
          end
        end
      end
    end
    print(ws_name, full_closed and "has been closed" or "has been part closed")
  end)
end

-- 打开指定的工作空间
ws.open = function(ws_name)
  if not ws_name then
    return
  end
  ws_name = regularize_ws_name(ws_name)
  local data = ws.read_data()
  if data and data[ws_name] then
    local filename = data[ws_name].filename
    if filename and utils.fs.exists(filename) then
      -- 必须在vim.schedule中执行，否则VimEnter事件触发时可能还未设置到autocmd
      vim.schedule(function()
        pcall(function()
          -- 如果缓冲区冲突此处会出现异常，使用pcall忽略
          vim.api.nvim_command("edit " .. filename)
          -- 强制刷新filetype，在切换filtype时需要这么做
          vim.api.nvim_command("filetype detect")
          vim.notify(ws_name .. " has been opened")
          utils.vim.cd(ws_name, filename)
          cur_ws = ws_name
        end)
      end)
    end
  end
end

-- 自动记录当前缓冲区对应的文件
ws.auto_record_file = function()
  if not utils.vim.is_sepcial_ft() and vim.bo.buftype ~= "nofile" then
    find_ws_and_do(function(ws_name, filename)
      ws.record_file(ws_name, filename)
      if not cur_ws or ws_name ~= cur_ws then
        utils.vim.cd(ws_name, filename)
        cur_ws = ws_name
      end
    end, vim.fn.expand("%:p"))
  end
end

-- 自动加载
ws.auto_load = function()
  local filename = vim.fn.expand("%:p")
  if filename == nil or filename == "" then -- 只在无名缓冲区自动加载
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count == 1 then                 -- 仅在无内容时加载
      local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
      if not line or line == "" then
        find_ws_and_do(function(ws_name, _)
          ws.open(ws_name)
        end, vim.fn.getcwd())
      end
    end
  end
end

-- 自动移除
ws.auto_remove = function()
  local from = vim.fn.expand("%:p")
  if utils.lang.str_empty(from) then
    from = vim.fn.getcwd()
  end
  find_ws_and_do(function(ws_name, _)
    ws.remove(ws_name)
  end, from)
end

ws.setup = function()
  -- 重新打开时光标定位到退出时的位置
  vim.cmd([[
    if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"zz" | endif
    endif
  ]])

  vim.api.nvim_create_augroup("workspaces", { clear = true })
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = "workspaces",
    pattern = "*",
    callback = function()
      ws.auto_load()
    end
  })
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = "workspaces",
    pattern = "*",
    callback = function()
      ws.auto_record_file()
    end
  })
  vim.api.nvim_create_user_command("WorkspaceAdd", function(args)
    local ws_name = nil
    if args and args.fargs and #args.fargs > 0 then
      ws_name = args.fargs[1]
    end
    ws.add(ws_name)
  end, { nargs = "?", complete = "file" })
  vim.api.nvim_create_user_command("WorkspaceRemove", function(args)
    local ws_name = nil
    if args and args.fargs and #args.fargs > 0 then
      ws_name = args.fargs[1]
    end
    if ws_name then
      ws.remove(ws_name)
    else
      ws.auto_remove()
    end
  end, { nargs = "?", complete = "file" })
  vim.api.nvim_create_user_command("WorkspaceClose", function(args)
    local ws_name = nil
    if args and args.fargs and #args.fargs > 0 then
      ws_name = args.fargs[1]
    else
      ws_name = ws.current_ws_name()
    end
    if ws_name then
      ws.close(ws_name)
    end
  end, { nargs = "?" })
end

return ws
