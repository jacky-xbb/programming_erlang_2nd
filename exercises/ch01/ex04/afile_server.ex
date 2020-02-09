defmodule AfileServer do
  def start(dir), do: spawn(__MODULE__, :loop, [dir])

  def loop(dir) do
    receive do
      {:list_dir, client} ->
        send client, {self(), File.ls(dir)}
      {{:get_file, file}, client} ->
        full = Path.join(dir, file)
        send client, {self(), File.read(full)}
      {{:put_file, file, content}, client} ->
        full = Path.join(dir, file)
        result = case File.write(full, content) do
          :ok -> :ok
          {:error, _reason} -> :error
        end
        send client, {self(), result}
    end
  end

end
