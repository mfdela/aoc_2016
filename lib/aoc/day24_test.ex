defmodule Aoc.Day24Test do
  use ExUnit.Case

  import Elixir.Aoc.Day24

  def test_input() do
    """
    ###########
    #0.1.....2#
    #.#######.#
    #4.......3#
    ###########
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 14
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
