defmodule MyTime do
  def my_time_func(f) do
    begin_time = :erlang.system_time(:microsecond)
    f.()
    end_time = :erlang.system_time(:microsecond)
    end_time - begin_time
  end
end
