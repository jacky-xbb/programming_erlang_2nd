require Logger

defmodule MySpawn do
  def on_exit(pid, fun) do
    spawn(fn ->
      ref = Process.monitor(pid)
      receive do
        {:DOWN, ^ref, :process, _object, reason} ->
          fun.(reason)
      end
    end)
  end

  def my_spawn(mod, fun, args) do
    pid = spawn(mod, fun, args)
    # Get the start time
    :erlang.statistics(:wall_clock)

    # TODO: WHAT if the pid process fails here?
    spawn(fn ->
      on_exit(pid, fn(reason) ->
        {_, wall_time} = :erlang.statistics(:wall_clock)
        Logger.info("Process #{inspect pid} lived for #{wall_time} milliseconds,")
        Logger.info("then died due to #{inspect reason}")
      end)
    end)

    pid
  end

  def atomize() do
    receive do
      str ->
        String.to_atom(str)
    end
  end

  def test() do
    IO.puts "testing..."
    atomizer = my_spawn(__MODULE__, :atomize, [])

    # let automize() run for a while
    Process.sleep(2000)
    send(atomizer, :hello)
  end

end
