defmodule Kvs do

  def start(), do: Process.register(spawn(&loop/0), :kvs)

  def store(key, value), do: rpc({:store, key, value})
  def lookup(key), do: rpc({:lookup, key})

  defp rpc(req) do
    send(:kvs, {self(), req})
    receive do
      {:kvs, reply} ->
        reply
    end
  end

  def loop() do
    receive do
      {from, {:store, key, value}} ->
        Process.put(key, {:ok, value})
        send(from, {:kvs, :true})
        loop()
      {from, {:lookup, key}} ->
        send(from, {:kvs, Process.get(key)})
        loop()
    end
  end

end
