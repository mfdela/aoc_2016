defmodule Aoc.Day14Test do
  use ExUnit.Case

  import Elixir.Aoc.Day14

  def test_input() do
    "abc"
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 22728
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 22551
  end
end
