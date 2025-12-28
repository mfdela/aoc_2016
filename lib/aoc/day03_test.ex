defmodule Aoc.Day03Test do
  use ExUnit.Case

  import Elixir.Aoc.Day03

  def test_input() do
    """
    5 10 25
    """
  end

  def test_input2() do
    """
    101 301 501
    102 302 502
    103 303 503
    201 401 601
    202 402 602
    203 403 603
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 0
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 6
  end
end
