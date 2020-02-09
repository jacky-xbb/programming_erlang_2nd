defmodule AfileClient do
  def ls(server) do
    send server, {:list_dir, self()}

    receive do
      {_server, file_list} ->
        file_list
    end
  end

  def get_file(server, file) do
    send server, {{:get_file, file}, self()}
    receive do
      {_server, content} ->
        content
    end
  end

  def put_file(server, file, content) do
    send server, {{:put_file, file, content}, self()}
    receive do
      {_server, result} ->
        result
    end
  end
end
