defmodule ReverseBytes do
  def reverse(binary) do
    binary
    |> :erlang.binary_to_list()
    |> Enum.reverse()
    |> :erlang.list_to_binary()
  end
end
