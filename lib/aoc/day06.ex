defmodule Aoc.Day06 do
  def part1(args) do
    args
    |> parse_input()
    |> rearrange()
    |> find_most_common_letters()
  end

  def part2(args) do
    args
    |> parse_input()
    |> rearrange()
    |> find_least_common_letters()
  end

  def rearrange(input) do
    input
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.frequencies/1)
  end

  def find_most_common_letters(input) do
    input
    |> Enum.map(&Enum.max_by(&1, fn letter_frequency -> elem(letter_frequency, 1) end))
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
  end

  def find_least_common_letters(input) do
    input
    |> Enum.map(&Enum.min_by(&1, fn letter_frequency -> elem(letter_frequency, 1) end))
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
