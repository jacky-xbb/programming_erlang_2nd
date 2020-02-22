defmodule AreaServer1 do
  def rpc(pid, request) do
    send(pid, {self(), request})
    receive do
      response ->
        response
    end
  end

  def loop() do
    receive do
      {from, {:rectangle, width, ht}} ->
        send(from, width * ht)
        loop()
      {from, {:circle, r}} ->
        send(from, 3.14159 * r *r)
        loop()
      {from, other} ->
        send(from, {:error, other})
        loop()
    end
  end

end
