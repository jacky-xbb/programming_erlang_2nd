defmodule AreaServer0 do
  def loop() do
    receive do
      {:rectangle, width, ht} ->
        IO.puts "Area of rectangle is #{width * ht}"
        loop()
      {:square, side} ->
        IO.puts "Area of square is #{side * side}"
        loop()
    end
  end
end
