defmodule Aoc.Day06Test do
  use ExUnit.Case

  import Elixir.Aoc.Day06

  def test_input() do
    """
    eedadn
    drvtee
    eandsr
    raavrd
    atevrs
    tsrnev
    sdttsa
    rasrtv
    nssdts
    ntnada
    svetve
    tesnvt
    vntsnd
    vrdear
    dvrsen
    enarar
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == "easter"
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == "advent"
  end
end
