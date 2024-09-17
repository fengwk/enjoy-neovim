local utils = require("fengwk.utils")
local md5 = require("fengwk.plugins.bookmarks.md5")

local data_path = utils.fs.stdpath("data", "bookmarks.json")

local data_cache = nil
local data_cache_pre_read = 0
local data_cache_read_min_interval = 1e6 * 500 -- 500毫秒，配置读取最小间隔时间

local function write_data(data)
  data_cache = data
  utils.fs.write_data(data_path, data_cache)
end

local function read_data()
  local cur_nanos = vim.loop.hrtime()
  if cur_nanos < data_cache_pre_read + data_cache_read_min_interval and data_cache then
    return data_cache
  end
  data_cache = utils.fs.read_data(data_path)
  data_cache_pre_read = cur_nanos
  return data_cache
end

local function add_mark_item(mark_item)
  if not mark_item then
    return
  end
  local data = read_data() or {}
  data[mark_item.hash] = mark_item
  write_data(data)
end

local function remove_mark_item(hash)
  if not hash then
    return
  end
  local data = read_data() or {}
  if not data[hash] then
    return
  end
  local new_data = {}
  for k, v in pairs(data) do
    if k ~= hash then
      new_data[k] = v
    end
  end
  write_data(new_data)
end

local function update_col(hash, col)
  if not hash then
    return
  end
  local data = read_data() or {}
  if not data[hash] then
    return
  end
  local new_data = {}
  for k, v in pairs(data) do
    if k ~= hash then
      new_data[k] = v
    else
      local new_v = vim.deepcopy(v)
      new_v.col = col
      new_data[k] = new_v
    end
  end
  write_data(new_data)
end

local hash = function(filename, line)
  local text = filename .. "|" .. line
  text = vim.trim(text)
  return md5.sumhexa(text)
end

local function add_mark(annotation)
  if utils.vim.is_sepcial_ft() then
    vim.notify("current ft cannot add bookmarks")
  end
  local filename = vim.fn.expand("%:p")
  if utils.fs.is_uri(filename) then
    vim.notify("current file cannot add bookmarks")
  end
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()
  local mark_item = {
    filename = filename,
    annotation = annotation and #annotation > 0 and annotation or vim.trim(current_line:sub(1, 20)),
    row = row,
    hash = hash(filename, current_line)
  }
  add_mark_item(mark_item)
end

local function remove_mark()
  local filename = vim.fn.expand("%:p")
  local current_line = vim.api.nvim_get_current_line()
  remove_mark_item(hash(filename, current_line))
end

local function get_real_row(mark_item)
  local row = mark_item.row
  local last = vim.fn.line("$")
  local filename = vim.fn.expand("%:p")
  if row <= last then
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    local h = hash(filename, line)
    if mark_item.hash == h then
      return row
    end
  end

  -- 走到这里说明无法匹配，尝试进行修复
  local r = math.min(row, last) - 1
  while r >= 1 do
    local line = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1]
    local h = hash(filename, line)
    if mark_item.hash == h then
      update_col(h, r)
      return r
    end
    r = r - 1
  end
  r = math.min(row, last) + 1
  while r <= last do
    local line = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1]
    local h = hash(filename, line)
    if mark_item.hash == h then
      update_col(h, r)
      return r
    end
    r = r + 1
  end

  -- 无法匹配返回-1
  return -1
end

local function open_mark(hash)
  if not hash then
    return
  end
  local data = read_data()
  if not data or not data[hash] then
    return
  end
  local mark_item = data[hash]
  if not utils.fs.exists(mark_item.filename) then
    vim.notify("bookmarks broken '" .. mark_item.annotation .. "'")
  end
  -- 必须在vim.schedule中执行，否则VimEnter事件触发时可能还未设置到autocmd
  vim.schedule(function()
    local ok = pcall(function()
      -- 如果缓冲区冲突此处会出现异常，使用pcall忽略
      vim.api.nvim_command("edit " .. mark_item.filename)
      -- 强制刷新filetype，在切换filtype时需要这么做
      vim.api.nvim_command("filetype detect")
    end)
    if ok then
      local row = get_real_row(mark_item)
      if row >= 0 then
        vim.api.nvim_win_set_cursor(0, { row, 0 })
      else
        vim.notify("bookmarks broken '" .. mark_item.annotation .. "'")
      end
    end
  end)
end

local function list_marks()
  local list = {}
  local data = read_data() or {}
  for _, v in pairs(data) do
    table.insert(list, vim.deepcopy(v))
  end
  return list
end

local function setup()
  -- vim.fn.sign_define("bookmark", { text = "🔖" })
  -- vim.api.nvim_create_autocmd({ "BufEnter" }, {
  --   group = "workspaces",
  --   pattern = "*",
  --   callback = function()
  --     ws.auto_record_file()
  --   end
  -- })
  -- vim.api.nvim_create_user_command("BookmarkAdd", function(args)
  --   local annotation = nil
  --   if args and args.fargs and #args.fargs > 0 then
  --     annotation = args.fargs[1]
  --   end
  --   bm.add_mark(annotation)
  -- end, { nargs = "?" })
  -- vim.api.nvim_create_user_command("BookmarkRemove", function()
  --   bm.remove_mark()
  -- end, {})
  vim.keymap.set("n", "<leader>mi", function()
    add_mark(vim.fn.input("Bookmark Annotation: "))
  end, { silent = true, desc = "Pates Image To Markdown" })
  vim.api.nvim_create_user_command("Bookmark Insert", function()
    add_mark(vim.fn.input("Bookmark Annotation: "))
  end, {})
end

-- export
return {
  remove_mark_item = remove_mark_item,
  add_mark         = add_mark,
  remove_mark      = remove_mark,
  open_mark        = open_mark,
  list_marks       = list_marks,
  setup            = setup,
}
