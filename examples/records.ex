defmodule Todo do
  require Record

  Record.defrecord(:todo, status: :reminder, who: :joe, text: nil)
end
