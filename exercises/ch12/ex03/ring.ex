require Logger

defmodule Ring do
  def ring(num_procs, num_loops) do
    start_pid = self()
    next_pid = spawn(fn -> create_ring(num_procs-1, start_pid) end)
    send(next_pid, {num_loops, "hello"})
    ring_start(next_pid)
  end

  def create_ring(1, start_pid), do: loop(start_pid)
  def create_ring(num_procs, start_pid) do
    next_pid = spawn(fn  -> create_ring(num_procs-1, start_pid) end)
    loop(next_pid)
  end

  # recevice loop for the `start` process.
  def ring_start(next_pid) do
    receive do
      {1, msg} ->
        Logger.info("**ring_start #{inspect self()} received: #{msg} (1)")
        send(next_pid, :stop)
      {num_loops, msg} ->
        Logger.info("**ring_start #{inspect self()} received: #{msg} (#{num_loops})")
        send(next_pid, {num_loops-1, msg})
        ring_start(next_pid)
    end
  end

  # receive loop for the other processes.
  def loop(next_pid) do
    receive do
      {num_loops, msg} ->
        Logger.info("Process #{inspect self()} received: #{msg} (#{num_loops})")
        send(next_pid, {num_loops, msg})
        loop(next_pid)
      :stop ->
        send(next_pid, :stop)
    end

  end
end
