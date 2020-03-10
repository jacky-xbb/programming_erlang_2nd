require Logger

defmodule ProcessMonitor do

  def monitor_workers_init(func_list) do
    spawn(__MODULE__, :monitor_workers, [func_list])
  end

  def monitor_workers(func_list) do
    workers = for func <- func_list do
      {spawn_monitor(func), func}
    end
    monitor_workers_loop(workers)
  end

  def monitor_workers_loop(workers) do
    receive do
      {:DOWN, _ref, :process, _pid, _reason} ->
        Logger.info("old workers: #{inspect workers}")
        new_workers = stop_and_restart_workers(workers)
        Logger.info("new workers: #{inspect new_workers}")
        monitor_workers_loop(new_workers)

      {:stop} ->
        Enum.each(workers, fn {{pid, _ref}, _func} -> send(pid, :stop) end)
        Logger.info("Monitor send stop message to all wrokers.")
        Logger.info("Monitor terminating: normal.")

      {:kill_worker, _from} ->
        kill_rand_worker(workers)
        monitor_workers_loop(workers)
    end
  end

  def stop_and_restart_workers(workers) do
    Enum.each(workers, fn {{pid, ref}, _func} ->
      send(pid, :stop)
      Process.demonitor(ref)
    end)

    Enum.map(workers, fn {{_pid, _ref}, func} ->
      {spawn_monitor(func), func}
    end)
  end

  def kill_rand_worker(workers) do
    {{pid, _ref}, _func}  = Enum.random(workers)
    Logger.info("Killing #{inspect pid}")
    Process.exit(pid, :kill)
  end

  def stop_monitor(monitor), do: send(monitor, {:stop})

  # ======== TESTS ===========
  def worker(n) do
    receive do
      :stop ->
        Logger.info("Worker #{n} stopping: normal.")
      after n * 1000 ->
        Logger.info("Worker #{n} is still alive.")
        worker(n)
    end
  end

  def test() do
    monitor = Enum.to_list(1..4)
    |> Enum.map(fn n -> fn  -> worker(n) end end)
    |> monitor_workers_init

    Logger.info("Monitor is: #{inspect monitor}")

    # Let monitored processes run for awhile
    Process.sleep(3000)
    # kill_workers(monitor, 5)
    kill_a_worker(monitor)

    Process.sleep(5000)
    stop_monitor(monitor)
  end

  def kill_a_worker(monitor) do
    send(monitor, {:kill_worker, self()})
  end

end
