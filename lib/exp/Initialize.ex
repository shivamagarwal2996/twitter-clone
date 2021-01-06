defmodule Initialize do

  def initializeRoute(l1, uid) do
    Enum.reduce 0..8, %{}, fn x, acc ->
      Map.put(acc, x, routeForLevel(uid, x, l1))
    end
  end

  def routeForLevel(uid, level, l1) do
    Enum.map(0..15, fn (x) -> routeForChar(uid, level, x, l1) end)
  end

  def routeForChar(uid, level, decimal, l1) do
    char = Integer.to_string(decimal, 16)
    prefix = String.slice(uid, 0, level) + char
    l1 = prefixFilter(prefix, l1)
    closest(uid, l1)
  end

  def prefixFilter(prefix, l1) do
    Enum.filter(l1, fn x -> String.starts_with?(x, prefix) end)
  end

  def closest(hex, l1) do
    min = {hex,100000000000000,"0"}
    min = Enum.reduce l1,min,fn(x, min) ->
      mi(x, min)
    end
    {_hex1, _dmin, hexmin} = min
    hexmin
  end

  def mi(hex2, min) do
    {hex1, dmin, _hexmin} = min
    dis = distance(hex1, hex2)
    if dis < dmin do
      {hex1, dis, hex2}
    else
      min
    end
  end

  def distance(hex1, hex2) do
    {p1,_a1} = Integer.parse(hex1, 16)
    {p2,_a2} = Integer.parse(hex2, 16)
    abs(p1-p2)
  end
end
