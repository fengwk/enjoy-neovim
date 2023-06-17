local lang = {}

lang.empty_str = function(s)
  return not s or #vim.trim(s) == 0
end

return lang
