defmodule Aoc.Day12Test do
  use ExUnit.Case

  import Elixir.Aoc.Day12

  def test_input() do
    """
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 42
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 42
  end
end
