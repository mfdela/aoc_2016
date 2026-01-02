defmodule Aoc.Day15Test do
  use ExUnit.Case

  import Elixir.Aoc.Day15

  def test_input() do
    """
    Disc #1 has 5 positions; at time=0, it is at position 4.
    Disc #2 has 2 positions; at time=0, it is at position 1.
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 5
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
