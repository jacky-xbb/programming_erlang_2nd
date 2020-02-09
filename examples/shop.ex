defmodule Shop do
  def cost(:oranges), do: 5
  def cost(:newspaper), do: 8
  def cost(:apples), do: 2
  def cost(:pears), do: 9
  def cost(:milk), do: 7

  def total([{what, n} | t]), do: cost(what) * n + total(t)
  def total([]), do: 0
end
