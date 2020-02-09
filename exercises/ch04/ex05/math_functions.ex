defmodule MathFunctions do
  def even(x) do
    case rem(x, 2) do
      0 -> true
      1 -> false
    end
  end

  def odd(x), do: not even(x)
end
