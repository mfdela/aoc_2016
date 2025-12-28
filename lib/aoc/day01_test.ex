defmodule Aoc.Day01Test do
  use ExUnit.Case

  import Elixir.Aoc.Day01

  def test_input() do
    """
    R2, R2, R2
    """
  end

  def test_input2() do
    """
    R8, R4, R4, R8
    """
  end

  test "part1" do
    # input = test_input()
    # result = part1(input)

    # assert result == 2
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 4
  end
end
