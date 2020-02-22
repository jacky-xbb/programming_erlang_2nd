defmodule AreaServerFinal do

  # API
  def start(), do: spawn(__MODULE__, :loop, [])

  def area(pid, what), do: rpc(pid, what)


  defp rpc(pid, request) do
    send(pid, {self(), request})
    receive do
      {^pid, response} ->
        response
    end
  end

  def loop() do
    receive do
      {from, {:rectangle, width, ht}} ->
        send(from, {self(), width * ht})
        loop()
      {from, {:circle, r}} ->
        send(from, {self(), 3.14159 * r *r})
        loop()
      {from, other} ->
        send(from, {self(), {:error, other}})
        loop()
    end
  end

end
