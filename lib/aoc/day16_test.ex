defmodule Aoc.Day16Test do
  use ExUnit.Case

  import Elixir.Aoc.Day16

  def test_input() do
    "10000"
  end

  test "part1" do
    input = test_input()
    result = part1(input, 20)

    assert result == "01100"
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
