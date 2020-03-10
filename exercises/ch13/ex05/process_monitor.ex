require Logger

defmodule ProcessMonitor do
  @time_between_killings 2000

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
      {:DOWN, ref, :process, pid, _reason} ->
        new_workers = restart_worker({pid, ref}, workers)
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

  def restart_worker(pid_ref, workers) do
    {_, func} = List.keyfind(workers, pid_ref, 0)
    Logger.info("Restarting #{inspect elem(pid_ref, 0)}")
    new_pid_ref = spawn_monitor(func)
    List.keyfind(workers, pid_ref, 0)
    [{new_pid_ref, func} | workers]
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
    kill_workers(monitor, 5)

    Process.sleep(5000)
    stop_monitor(monitor)
  end

  def kill_workers(_monitor, 0), do: :ok
  def kill_workers(monitor, num_times) do
    send(monitor, {:kill_worker, self()})
    Process.sleep(@time_between_killings)
    kill_workers(monitor, num_times-1)
  end
end
