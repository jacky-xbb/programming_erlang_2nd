defmodule Shop2 do
  alias Mylists
  alias Shop

  def total(l) do
    Mylists.sum(Mylists.map(fn {what, n} -> Shop.cost(what) * n end, l))
  end
end
