defmodule Myfile do
  def read(file) do
    case File.read(file) do
      {:ok, body} -> IO.puts "Success: #{body}"
      {:error, reason} -> raise "Error: #{reason}"
    end
  end
end
