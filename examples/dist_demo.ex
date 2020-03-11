defmodule DistDemo do
  def start(node), do: Node.spawn(node, fn -> loop() end)

  def rpc(pid, m, f, a) do
    send(pid, {:rpc, self(), m, f, a})
    receive do
      {_pid, response} ->
        response
    end
  end

  def loop() do
    receive do
      {:rpc, pid, m, f, a} ->
        send(pid, {self(), apply(m, f, a)})
        loop()
    end
  end
end
