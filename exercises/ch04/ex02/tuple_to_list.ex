defmodule TupleToList do
  def tuple_to_list(tuple) do
    for index <- 1..tuple_size(tuple) do
      elem(tuple, index-1)
    end
  end
end
