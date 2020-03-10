require Logger

defmodule MySpawn do
  def my_spawn1(mod, fun, args) do
    pid = spawn(mod, fun, args)
    # Get the start time
    :erlang.statistics(:wall_clock)

    # TODO: WHAT if the pid process fails here?
    spawn(fn ->
      ref = Process.monitor(pid)
      receive do
        {:DOWN, ^ref, :process, _object, reason} ->
          {_, wall_time} = :erlang.statistics(:wall_clock)
          Logger.info("Process #{inspect pid} lived for #{wall_time} milliseconds,")
          Logger.info("then died due to #{inspect reason}")
      end
    end)

    pid
  end

  def my_spawn2(mod, fun, args) do
    pid = self()
    tag = :erlang.make_ref()

    # Get the start time
    :erlang.statistics(:wall_clock)

    monitor = spawn(fn ->
      {func_pid, ref} = spawn_monitor(mod, fun, args)
      send(pid, {self(), tag, func_pid})

      receive do
        {:DOWN, ^ref, :process, _object, reason} ->
          {_, wall_time} = :erlang.statistics(:wall_clock)
          Logger.info("Process #{inspect pid} lived for #{wall_time} milliseconds,")
          Logger.info("then died due to #{inspect reason}")
      end
    end)

    receive do
      {^monitor, ^tag, func_pid} -> func_pid
    end

  end

  def atomize() do
    receive do
      str ->
        String.to_atom(str)
    end
  end

  def test() do
    IO.puts "testing..."
    atomizer = my_spawn2(__MODULE__, :atomize, [])

    # let automize() run for a while
    Process.sleep(2000)
    send(atomizer, :hello)
  end

end
