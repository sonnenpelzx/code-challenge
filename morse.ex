defmodule Morse do
  def test() do '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '
  end
  def test2() do
    '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '
  end
  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
        {:node, 111,
          {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
          {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
        {:node, 103,
          {:node, 113, nil, nil},
          {:node, 122,
            {:node, :na, {:node, 44, nil, nil}, nil},
            {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end
  def smallest(nil) do 0 end
  def smallest({:node, char, nil, nil}) do char end
  def smallest({:node, char, node1, node2}) do
    n1 = smallest(node1)
    n2 = smallest(node2)
    if is_atom(char) do
      if n1 > n2 do
        n1
      else
        n2
      end
    else
      cond do
        n1 > n2 && n1 > char -> n1
        n2 > n1 && n2 > char -> n2
        true -> char
      end
    end
  end
  def treeToList(nil, _) do [] end
  def treeToList({:node, char, nil, nil}, code) do [{char, code}] end
  def treeToList({:node, char, node1,node2}, code) do
    if is_atom(char) do
      treeToList(node1, code <> "-") ++ treeToList(node2, code <> ".")
    else
      [{char, code}] ++ treeToList(node1, code <> "-") ++ treeToList(node2, code <> ".")
    end
  end
  def sortList(123, _) do [] end
  def sortList(key, list) do
    [find(list, key)] ++ sortList(key + 1, list)
  end
  def find([], _) do {nil, nil} end
  def find([{char, code}|rest], key) do
    if char == key do
      {char, to_charlist(code)}
    else
      find(rest, key)
    end
  end
  def encodeTable() do
    list = treeToList(morse(),"")
    list = sortList(32, list)
    List.to_tuple(list)
  end
  def lookupCode(table, char) do
    {_, code} = elem(table, char - 32)
    code
  end
  def encode(text) do 
    table = encodeTable()
    encode(text, table, [])
  end
  def encode([], _, acc) do Enum.reverse(acc) end
  def encode([char|rest], table, acc) do
    encode(rest, table, [32| lookupCode(table, char) ++ acc])
  end
  def decodeChar(code) do decodeChar(morse(), code) end
  def decodeChar({:node, char, _, _}, []) do char end
  def decodeChar({:node, _, left, _right}, [45 | rest]) do
    decodeChar(left, rest)
  end
  def decodeChar({:node, _ , _left, right}, [46 | rest]) do
    decodeChar(right, rest)
  end
  def decode(code) do decode(code, [], []) end
  def decode([], [], text) do to_string(Enum.reverse(text)) end
  def decode([], char, text) do to_string(Enum.reverse([decodeChar(char)| text])) end
  def decode([32|rest], char, text) do decode(rest, [], [decodeChar(Enum.reverse(char))|text]) end
  def decode([code|rest], char, text) do decode(rest, [code|char], text) end
end
