defmodule Challenge do
  def test1() do
    [[0, 0, 1], [1, 0, 1]]
  end
  def test2() do
    [[1,1], [1,1]]
  end
  def test3() do
    [[1,0,0,1],[1,0,1,0],[1,0,0,0]]
  end
  def getHitProbability(field) do
    getHitProbability(field, 0, 0)
  end
  def getHitProbability([], ships, fields) do
    ships/fields
  end
  def getHitProbability([list | rest], ships, fields) do
    {s,  f} = List.foldl(list, {0, 0}, fn x, {s, f} -> {x + s, f + 1} end)
    getHitProbability(rest, ships + s, fields + f)
  end

end
