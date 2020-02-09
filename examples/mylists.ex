defmodule Mylists do
  def sum([h|t]), do: h + sum(t)
  def sum([]), do: 0

  def map(_f, []), do: []
  def map(f, [h|t]), do: [f.(h) | map(f, t)]
end
