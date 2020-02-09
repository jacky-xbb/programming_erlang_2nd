if !System.get_env("PROGRAMMING_ERLANG_TEST_EXAMPLES") do
  Code.load_file("geometry.ex", __DIR__)
end

ExUnit.start()

defmodule GeometryTest do
  use ExUnit.Case

  test "calculate the rectangle" do
    assert Geometry.area({:rectangle, 2, 3}) == 6
  end

  test "calculate the square" do
    assert Geometry.area({:square, 2}) == 4
  end

  test "calculate the circle" do
    assert Geometry.area({:circle, 2}) == 12.566370614359172
  end

  test "calculate the right angled triangle" do
    assert Geometry.area({:right_angled_triangle, 2, 3}) == 3
  end
end
