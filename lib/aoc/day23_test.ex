defmodule Aoc.Day23Test do
  use ExUnit.Case

  import Elixir.Aoc.Day23

  def test_input() do
    """
    cpy 2 a
    tgl a
    tgl a
    tgl a
    cpy 1 a
    dec a
    dec a
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

    assert result
  end
end
