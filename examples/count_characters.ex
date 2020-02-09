defmodule CountCharacters do
  def count_characters(l) do
    Enum.reduce(
      l,
      %{},
      fn x, acc -> Map.update(acc, x, 1, &(&1+1)) end
    )
  end
end
