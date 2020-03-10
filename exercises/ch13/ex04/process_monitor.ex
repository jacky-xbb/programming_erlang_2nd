require Logger

defmodule ProcessMonitor do
  @five_seconds 3000
  @registered_name :long_living

  def register_init() do
    Process.register(pid=spawn(__MODULE__, :func, []), @registered_name)
    pid
  end

  def func() do
    receive do
    after @five_seconds ->
        Logger.info("I'm still runing")
        func()
    end
  end

  def monitor_init(pid, restart_fun) do
    # on_exit(pid, fn ->
    #   new_pid = restart_fun()
    #   monitor_init(new_pid, restart_fun)
    # end)
    on_exit(pid, restart_fun)
  end

  defp on_exit(pid, fun) do
    spawn(fn ->
      ref = Process.monitor(pid)
      receive do
        {:DOWN, ^ref, :process, object, reason} ->
          Logger.warn("#{inspect object} went down: #{inspect reason} \n restarting...")
          fun.()
      end
    end)
  end

  def test() do
    pid = register_init()

    Logger.info("before killed: #{inspect Process.whereis(@registered_name)}")
    monitor_init(pid, &register_init/0)
    # Kill the monitored process
    Process.exit(pid, :kill)
    # Sleep for a while
    Process.sleep(2000)
    # Check if it's restarted
    Logger.info("after killed: #{inspect Process.whereis(@registered_name)}")

    :pass
  end

end
