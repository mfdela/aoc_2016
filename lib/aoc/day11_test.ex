defmodule Aoc.Day11Test do
  use ExUnit.Case

  import Elixir.Aoc.Day11

  def test_input() do
    """
    The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
    The second floor contains a hydrogen generator.
    The third floor contains a lithium generator.
    The fourth floor contains nothing relevant.
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
