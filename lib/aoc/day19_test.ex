defmodule Aoc.Day19Test do
  use ExUnit.Case

  import Elixir.Aoc.Day19

  def test_input() do
    5
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 3
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 2
  end
end
