defmodule Packet do
  def packet_to_term(packet) do
    <<_len::size(4), data::binary>> = packet
    :erlang.binary_to_term(data)
  end
end
