defmodule Aoc.Day20Test do
  use ExUnit.Case

  import Elixir.Aoc.Day20

  def test_input() do
    """
    5-8
    0-2
    4-7
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 3
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 1
  end
end
