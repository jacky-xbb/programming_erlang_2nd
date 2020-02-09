defmodule Geometry do
  def area({:rectangle, width, height}), do: width * height
  def area({:square, side}), do: side * side
  def area({:circle, radius}), do: :math.pi() * radius * radius
  def area({:right_angled_triangle, a, b}), do: a * b / 2
end



