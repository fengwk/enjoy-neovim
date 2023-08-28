local bit = require("fengwk.utils.bit")

local utf8 = {}

utf8.parse = function(s)
  local cs = {}
  local i = 1
  while i <= #s do
    local c = string.byte(s:sub(i, i))
    if bit.And(c, 0b11111100) == 0b11111100 then
      table.insert(cs, {
        s = s:sub(i, i + 5),
        n = 6,
      })
      i = i + 6;
    elseif bit.And(c, 0b11111000) == 0b11111000 then
      table.insert(cs, {
        s = s:sub(i, i + 4),
        n = 5,
      })
      i = i + 5;
    elseif bit.And(c, 0b11110000) == 0b11110000 then
      table.insert(cs, {
        s = s:sub(i, i + 3),
        n = 4,
      })
      i = i + 4;
    elseif bit.And(c, 0b11100000) == 0b11100000 then
      table.insert(cs, {
        s = s:sub(i, i + 2),
        n = 3,
      })
      i = i + 3;
    elseif bit.And(c, 0b11000000) == 0b11000000 then
      table.insert(cs, {
        s = s:sub(i, i + 1),
        n = 2,
      })
      i = i + 2;
    else
      table.insert(cs, {
        s = s:sub(i, i),
        n = 1,
      })
      i = i + 1;
    end
  end
  return cs
end

return utf8
