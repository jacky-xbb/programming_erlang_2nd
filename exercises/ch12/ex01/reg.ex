defmodule Reg do
  def start(an_atom, fun) do
    case Process.whereis(an_atom) do
      nil ->
        Process.register(spawn(fun), an_atom)
      _ ->
        {:error, {:name_taken, an_atom}}
    end
  end
end
