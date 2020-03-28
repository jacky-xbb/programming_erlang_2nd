defmodule UDPTest do

  def start_server(), do: spawn(fn -> server(4000) end)

  # The server
  def server(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary])
    IO.puts("Server opened socket: #{inspect socket}")
    loop(socket)
  end

  def loop(socket) do
    receive do
      {:udp, ^socket, host, port, bin} = msg ->
        IO.puts("Server received: #{inspect msg}")
        n = :erlang.binary_to_term(bin)
        result = fac(n)
        :gen_udp.send(socket, host, port, :erlang.term_to_binary(result))
        loop(socket)
    end
  end

  defp fac(0), do: 1
  defp fac(n), do: n * fac(n-1)

  # The client
  def client(n) do
    {:ok, socket} = :gen_udp.open(0, [:binary])
    IO.puts("Client opened socket: #{inspect socket}")
    :ok = :gen_udp.send(socket, 'localhost', 4000,
                :erlang.term_to_binary(n))
    value = receive do
      {:udp, ^socket, _host, _port, bin} = msg ->
        IO.puts("Client received: #{inspect msg}")
        :erlang.binary_to_term(bin)
      after 2000 ->
        0
    end
    :gen_udp.close(socket)
    value
  end



end
