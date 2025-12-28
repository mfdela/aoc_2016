defmodule Aoc.Day02Test do
  use ExUnit.Case

  import Elixir.Aoc.Day02

  def test_input() do
    """
    ULL
    RRDDD
    LURDL
    UUUUD
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == "1985"
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == "5DB3"
  end
end
