local utils = require("fengwk.utils")

local config_path = utils.fs.stdpath("data", "workspaces.json")

local ws = {}

ws.write_conf = function(conf)
  return utils.fs.write_conf(config_path, conf)
end

ws.read_conf = function()
  return utils.fs.read_conf(config_path)
end

ws.add = function(ws_name, ignore_exists)
  ws_name = ws_name or vim.fn.getcwd()
  ws_name = vim.fn.expand(ws_name)
  local conf = ws.read_conf()
  if conf and conf[ws_name] then
    if not ignore_exists then
      vim.notify(ws_name .. " already exists")
    end
    return
  end
  if not conf then
    conf = {}
  end
  conf[ws_name] = {}
  local filename = vim.fn.expand("%:p")
  if filename and filename ~= "" then
    conf[ws_name].filename = filename
  end
  vim.notify(ws_name .. " has been added to workspaces")
  ws.write_conf(conf)
end

ws.remove = function(ws_name)
  ws_name = ws_name or vim.fn.getcwd()
  ws_name = vim.fn.expand(ws_name)
  local conf = ws.read_conf()
  if not conf or not conf[ws_name] then
    vim.notify(ws_name .. " cannot found")
    return
  end
  local new_conf = {}
  for k, v in pairs(conf) do
    if k ~= ws_name then
      new_conf[k] = v
    end
  end
  ws.write_conf(new_conf)
  vim.notify(ws_name .. " has been removed from workspaces")
end

ws.list = function()
  local conf = ws.read_conf()
  local ws_list = {}
  if conf then
    for k, _ in pairs(conf) do
      table.insert(ws_list, k)
    end
  end
  return ws_list
end

ws.record_file = function(ws_name, filename)
  if not ws_name or not filename then
    return
  end
  ws_name = vim.fn.expand(ws_name)
  local conf = ws.read_conf()
  if not conf or not conf[ws_name] then
    return
  end
  if not filename or utils.fs.is_uri(filename) then
    return
  end
  utils.fs.iter_path_to_root(filename, function(cur_path)
    if cur_path == ws_name then
      local ws_conf = conf[ws_name]
      ws_conf.filename = filename
      ws.write_conf(conf)
      return false
    end
    return true
  end)
end

ws.open = function(ws_name)
  if not ws_name then
    return
  end
  ws_name = vim.fn.expand(ws_name)
  local conf = ws.read_conf()
  if conf and conf[ws_name] then
    local filename = conf[ws_name].filename
    if filename then
      vim.schedule(function()
        pcall(function()
          -- 如果缓冲区冲突此处会出现异常，使用pcall忽略
          vim.api.nvim_command("edit " .. filename)
          vim.notify(ws_name .. " has been opened")
        end)
      end)
    end
    utils.vim.cd(ws_name, filename)
  end
end

local function find_ws_and_do(do_func, from)
  if not do_func or utils.lang.empty_str(from) then
    return
  end
  local conf = ws.read_conf()
  if not conf then
    return
  end
  utils.fs.iter_path_to_root(from, function(cur_path)
    if conf[cur_path] then
      do_func(cur_path, from)
      return false
    end
    return true
  end)
end

ws.auto_record_file = function()
  find_ws_and_do(function(ws_name, filename)
    ws.record_file(ws_name, filename)
    utils.vim.cd(ws_name, filename)
  end, vim.fn.expand("%:p"))
end

ws.auto_load = function()
  local filename = vim.fn.expand("%:p")
  if filename == nil or filename == "" then -- 只在无名缓冲区自动加载
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count == 1 and vim.cmd("echo getline(1)") == "" then -- 仅在无内容时加载
      find_ws_and_do(function(ws_name, _)
        ws.open(ws_name)
      end, vim.fn.getcwd())
    end
  end
end

ws.auto_remove = function(ws_name)
  if ws_name then
    ws.remove(ws_name)
  else
    local from = vim.fn.expand("%:p")
    if utils.lang.empty_str(from) then
      from = vim.fn.getcwd()
    end
    find_ws_and_do(function(ws_name, _)
      ws.remove(ws_name)
    end, from)
  end
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
  end, { nargs = "?" })
  vim.api.nvim_create_user_command("WorkspaceRemove", function(args)
    local ws_name = nil
    if args and args.fargs and #args.fargs > 0 then
      ws_name = args.fargs[1]
    end
    ws.auto_remove(ws_name)
  end, { nargs = "?" })
end

return ws
