defmodule Aoc.Day08Test do
  use ExUnit.Case

  import Elixir.Aoc.Day08

  def test_input() do
    """
    rect 3x2
    rotate column x=1 by 1
    rotate row y=0 by 4
    rotate column x=1 by 1
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, 3, 7)

    assert result == 6
  end

  test "part2" do
    input = test_input()
    result = part2(input, 3, 7)

    assert result
  end
end
