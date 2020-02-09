defmodule MapSearch do
  def map_search_pred(map, pred) do
    Enum.find(
      Map.to_list(map),
      fn {k, v} -> pred.(k, v) end
    )
  end
end
