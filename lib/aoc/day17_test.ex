defmodule Aoc.Day17Test do
  use ExUnit.Case

  import Elixir.Aoc.Day17

  def test_input() do
    "ihgpwlah"
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == "DDRRRD"
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 370
  end
end
