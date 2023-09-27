local lang = {}

lang.str_empty = function(s)
  return not s or #vim.trim(s) == 0
end

lang.str_index = function(str, pattern)
  local i = 1
  local j = 1
  while i <= #str and j <= #pattern do
    if str:sub(i, i) == pattern:sub(j, j) then
      i = i + 1
      j = j + 1
    else
      i = i - j + 2
      j = 1
    end
  end
  return j == #pattern + 1 and i - #pattern or 0
end

return lang
