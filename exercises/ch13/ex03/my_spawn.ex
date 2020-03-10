require Logger

defmodule MySpawn do
  def my_spawn(mod, fun, args, time) do
    pid = spawn(mod, fun, args)

    spawn(fn ->
      receive do
      after time ->
        Logger.info("sent 'kill' signal after #{time} milliseconds")
        Process.exit(pid, :kill)
      end
    end)

    pid
  end

  def loop(n) do
    receive do
    after 1000 ->
      Logger.info("loop(): tick #{n}")
      loop(n+1)
    end
  end

  def test() do
    my_spawn(__MODULE__, :loop, [1], 5300)
    :testing
  end
end
