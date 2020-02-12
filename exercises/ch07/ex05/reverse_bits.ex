defmodule ReverseBits do
  # def reverse(binary) do
  #   binary
  #   |> :erlang.bitstring_to_list()
  #   |> Enum.reverse()
  #   |> :erlang.list_to_bitstring()
  # end

  def reverse(binary), do: reverse(binary, <<>>)

  defp reverse(<<>>, result), do: result
  defp reverse(<<bit::1, rest::bitstring>>, result), do: reverse(rest, <<bit, result::bitstring>>)
end
