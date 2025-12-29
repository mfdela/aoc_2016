defmodule Aoc.Day07Test do
  use ExUnit.Case

  import Elixir.Aoc.Day07

  def test_input() do
    """
    abba[mnop]qrst
    abcd[bddb]xyyx
    aaaa[qwer]tyui
    ioxxoj[asdfgh]zxcvbn
    """
  end

  def test_input2() do
    """
    aba[bab]xyz
    xyx[xyx]xyx
    aaa[kek]eke
    zazbz[bzb]cdb
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 2
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 3
  end
end
