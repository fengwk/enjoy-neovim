local bit = {}

bit.And = function(a, b)
  local res = 0
  local bi = 1
  while a > 0 and b > 0 do
    if a % 2 == 1 and b % 2 == 1 then
      res = res + bi
    end
    a = bit.Right(a, 1)
    b = bit.Right(b, 1)
    bi = bit.Left(bi, 1)
  end
  return res
end

bit.Or = function(a, b)
  local res = 0
  local bi = 1
  while a > 0 or b > 0 do
    if a % 2 == 1 and b % 2 == 1 then
      res = res + bi
    end
    a = bit.Right(a, 1)
    b = bit.Right(b, 1)
    bi = bit.Left(bi, 1)
  end
  return res
end

bit.Left = function(a, bit)
  local i = 0
  while i < bit do
    a = a * 2
    i = i + 1
  end
  return a
end

bit.Right = function(a, bit)
  local i = 0
  while i < bit do
    a = math.floor(a / 2)
    i = i + 1
  end
  return a
end

return bit
