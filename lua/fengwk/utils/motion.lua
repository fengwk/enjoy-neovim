local motion = {}

local function is_blockwise(vmode)
  return vmode:byte() == 22 or vmode == "block" or vmode == "b"
end

local function is_visual(vmode)
  return vmode:match("[vV]") or is_blockwise(vmode)
end

local function get_register_type(vmode)
  if is_blockwise(vmode) or "b" == vmode then
    return "b"
  end

  if vmode == "V" or vmode == "line" or vmode == "l" then
    return "l"
  end

  return "c"
end

local function text(bufnr, start, finish, vmode)
  if start.row > finish.row then
    return { "" }
  end

  local regtype = get_register_type(vmode)
  if "l" == regtype then
    return vim.api.nvim_buf_get_lines(bufnr, start.row - 1, finish.row, false)
  end

  if "b" == regtype then
    local text = {}
    for row = start.row, finish.row, 1 do
      local current_row_len = vim.fn.getline(row):len()

      local end_col = current_row_len > finish.col and finish.col + 1 or current_row_len
      if start.col > end_col then
        end_col = start.col
      end

      local lines = vim.api.nvim_buf_get_text(bufnr, row - 1, start.col, row - 1, end_col, {})

      for _, line in pairs(lines) do
        table.insert(text, line)
      end
    end

    return text
  end

  return vim.api.nvim_buf_get_text(0, start.row - 1, start.col, finish.row - 1, finish.col + 1, {})
end

local function get_marks(bufnr, vmode)
  local start_mark, finish_mark = "[", "]"
  if is_visual(vmode) then
    start_mark, finish_mark = "<", ">"
  end

  local pos_start = vim.api.nvim_buf_get_mark(bufnr, start_mark)
  local pos_finish = vim.api.nvim_buf_get_mark(bufnr, finish_mark)

  return {
    start = {
      row = pos_start[1],
      col = pos_start[2],
    },
    finish = {
      row = pos_finish[1],
      col = pos_finish[2],
    },
  }
end

local function set_trap(handler, m, mode)
  motion.handler = handler or function(_) end
  vim.api.nvim_set_option("operatorfunc", "v:lua.require'fengwk.utils.motion'.callback")
  vim.api.nvim_feedkeys("g@" .. (m or ""), mode or "mi", false)
end

motion.substitute_text = function(bufnr, start, finish, regtype, replacement, replacement_regtype)
  regtype = get_register_type(regtype)

  if "l" == regtype then
    vim.api.nvim_buf_set_lines(bufnr, start.row - 1, finish.row, false, replacement)

    local end_mark_col = string.len(replacement[#replacement]) + 1
    local end_mark_row = start.row + vim.tbl_count(replacement) - 1

    return { { start = { row = start.row, col = 0 }, finish = { row = end_mark_row, col = end_mark_col } } }
  end

  if is_blockwise(regtype) then
    if is_blockwise(replacement_regtype) then
      local marks = {}
      for row = start.row, finish.row, 1 do
        if start.col > finish.col then
          start.col, finish.col = finish.col, start.col
        end
        local current_row_len = vim.fn.getline(row):len()
        local last_replacement = table.remove(replacement, 1) or ""
        if current_row_len > 0 then
          vim.api.nvim_buf_set_text(
            bufnr,
            row - 1,
            start.col,
            row - 1,
            current_row_len > finish.col and finish.col + 1 or current_row_len,
            { last_replacement }
          )

          table.insert(marks, {
            start = { row = row, col = start.col },
            finish = { row = row, col = start.col + string.len(last_replacement) },
          })
        end
      end

      return marks
    end

    local marks = {}
    for row = finish.row, start.row, -1 do
      local current_row_len = vim.fn.getline(row):len()
      if start.col > finish.col then
        start.col, finish.col = finish.col, start.col
      end

      if current_row_len > 0 then
        vim.api.nvim_buf_set_text(
          bufnr,
          row - 1,
          current_row_len > start.col and start.col or current_row_len,
          row - 1,
          current_row_len > finish.col and finish.col + 1 or current_row_len,
          replacement
        )

        local end_mark_col = string.len(replacement[#replacement])
        if vim.tbl_count(replacement) == 1 then
          end_mark_col = end_mark_col + start.col
        end
        table.insert(marks, 1, {
          start = { row = row, col = start.col },
          finish = { row = row, col = end_mark_col },
        })
      end
    end

    return marks
  end

  if start.row > finish.row then
    vim.api.nvim_buf_set_text(bufnr, start.row - 1, start.col, start.row - 1, start.col, replacement)
  else
    local current_row_len = vim.fn.getline(finish.row):len()
    vim.api.nvim_buf_set_text(
      bufnr,
      start.row - 1,
      start.col,
      finish.row - 1,
      current_row_len > finish.col and finish.col + 1 or current_row_len,
      replacement
    )
  end

  local end_mark_col = string.len(replacement[#replacement])
  if vim.tbl_count(replacement) == 1 then
    end_mark_col = end_mark_col + start.col
  end
  local end_mark_row = start.row + vim.tbl_count(replacement) - 1

  return { { start = start, finish = { row = end_mark_row, col = end_mark_col } } }
end

motion.callback = function(vmode)
  local marks = get_marks(0, vmode)
  local textobject = text(0, marks.start, marks.finish, vmode)
  motion.handler({
    marks = marks,
    vmode = vmode,
    textobject = textobject,
  })
end

motion.operator = function(handler)
  set_trap(handler)
end

motion.line = function(handler)
  local count = vim.v.count > 0 and vim.v.count or ""
  set_trap(handler, count .. "_")
end

motion.eol = function(handler)
  set_trap(handler, "$")
end

motion.visual = function(handler)
  set_trap(handler, "`<", "ni")
end

return motion
