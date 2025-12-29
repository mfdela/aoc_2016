defmodule Aoc.Day09Test do
  use ExUnit.Case

  import Elixir.Aoc.Day09

  def test_input() do
    """
    X(8x2)(3x3)ABCY
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 18
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 20
  end
end
