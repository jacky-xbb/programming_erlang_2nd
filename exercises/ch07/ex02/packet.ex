defmodule Packct do
  def term_to_packet(term) do
    data = :erlang.term_to_binary(term)
    len = byte_size(data)
    <<len::size(4), data::binary>>
  end
end
