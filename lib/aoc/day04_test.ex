defmodule Aoc.Day04Test do
  use ExUnit.Case

  import Elixir.Aoc.Day04

  def test_input() do
    """
    aaaaa-bbb-z-y-x-123[abxyz]
    a-b-c-d-e-f-g-h-987[abcde]
    not-a-real-room-404[oarel]
    totally-real-room-200[decoy]
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 1514
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
