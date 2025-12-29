defmodule Aoc.Day05Test do
  use ExUnit.Case

  import Elixir.Aoc.Day05

  def test_input() do
    "abc"
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == "18f47a30"
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == "05ace8e3"
  end
end
