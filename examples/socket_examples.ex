defmodule SocketExample do
  def nano_get_url(), do: nano_get_url('wwww.baidu.com')

  def nano_get_url(host) do
    {:ok, socket} = :gen_tcp.connect(host, 80, [:binary, packet: 0])
    :ok = :gen_tcp.send(socket, "GET / HTTP/1.0\r\n\r\n")
    receive_data(socket, [])
  end

  def receive_data(socket, so_far) do
    receive do
      {:tcp, ^socket, bin} ->
        receive_data(socket, [bin|so_far])
      {:tcp_closed, _socket} ->
        :erlang.list_to_binary(Enum.reverse(so_far))
    end
  end

  def nano_client_eval(str) do
    {:ok, socket} = :gen_tcp.connect('localhost', 2345, [:binary, packet: 4])
    :ok = :gen_tcp.send(socket, :erlang.term_to_binary(str))
    receive do
      {:tcp, socket, bin} ->
        IO.puts("Client received binary = #{inspect bin}")
        val = :erlang.binary_to_term(bin)
        IO.puts("Client result = #{inspect val}")
        :gen_tcp.close(socket)
    end
  end

  def start_nano_server() do
    {:ok, listen} = :gen_tcp.listen(2345,
                      [:binary, packet: 4, reuseaddr: true, active: true])
    {:ok, socket} = :gen_tcp.accept(listen)
    :gen_tcp.close(listen)
    loop(socket)
  end

  def loop(socket) do
    receive do
      {:tcp, ^socket, bin} ->
        IO.puts("Client received binary = #{inspect bin}")
        str = :erlang.binary_to_term(bin)
        IO.puts("Server (unpacked) = #{inspect str}")
        reply = Code.eval_string(str)
        IO.puts("Server replying = #{inspect reply}")
        :gen_tcp.send(socket, :erlang.term_to_binary(reply))
        loop(socket)
      {:tcp_closed, ^socket} ->
        IO.puts("Server socket closed")
    end
  end

end
