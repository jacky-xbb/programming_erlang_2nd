defmodule Processes do
  def max(n) do
    max = :erlang.system_info(:process_limit)
    IO.puts "Maximum allowed processes: #{max}"
    :erlang.statistics(:runtime)
    :erlang.statistics(:wall_clock)
    l = 1..n
    |> Enum.to_list()
    |> Enum.map(fn _ -> spawn(fn -> wait() end) end)
    {_, time1} = :erlang.statistics(:runtime)
    {_, time2} = :erlang.statistics(:wall_clock)
    Enum.each(l, fn(pid) -> send(pid, :die) end)
    u1 = time1 * 1000 / n
    u2 = time2 * 1000 / n
    IO.puts "Process spawn time = #{u1} (#{u2}) microseconds"
  end

  def wait() do
    receive do
      :die ->
        :void
    end
  end

end
