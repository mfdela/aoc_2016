defmodule Aoc.Day21Test do
  use ExUnit.Case

  import Elixir.Aoc.Day21

  def test_input() do
    """
    swap position 4 with position 0
    swap letter d with letter b
    reverse positions 0 through 4
    rotate left 1 step
    move position 1 to position 4
    move position 3 to position 0
    rotate based on position of letter b
    rotate based on position of letter d
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, "abcde")

    assert result == "decab"
  end

  test "part2" do
    input = test_input()
    result = part2(input, "abcde")

    assert result
  end
end
