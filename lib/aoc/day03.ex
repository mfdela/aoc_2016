defmodule Aoc.Day03 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.filter(&valid_triangle?/1)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> parse_input_part2()
    |> Enum.filter(&valid_triangle?/1)
    |> Enum.count()
  end

  def parse_input(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.split(row, " ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  def valid_triangle?(triangle) do
    [a, b, c] = Enum.sort(triangle)
    a + b > c
  end

  def parse_input_part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.split(row, " ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Aoc.Tools.Matrix.transpose()
    |> Enum.flat_map(fn row ->
      Enum.chunk_every(row, 3)
    end)
  end
end
