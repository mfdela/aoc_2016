defmodule Aoc.Day04 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.filter(&valid?(elem(&1, 0), elem(&1, 2)))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.map(&{decrypt(elem(&1, 0), elem(&1, 1)), elem(&1, 1)})
    |> Enum.filter(&String.starts_with?(elem(&1, 0), "northpole"))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def parse_input(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [name, sector_id, checksum] =
        Regex.run(~r/([a-z-]+)-(\d+)\[([a-z]+)\]/, row, capture: :all_but_first)

      {String.replace(name, "-", ""), String.to_integer(sector_id), checksum}
    end)
  end

  def valid?(name, checksum) do
    name
    |> String.graphemes()
    |> Enum.frequencies()
    |> Enum.sort_by(fn {char, count} -> {-count, char} end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.take(5)
    |> Enum.join()
    |> String.starts_with?(checksum)
  end

  def decrypt(name, sector_id) do
    name
    |> String.graphemes()
    |> Enum.map(fn char ->
      if char == "-" do
        " "
      else
        rotate_char(char, sector_id)
      end
    end)
    |> Enum.join()
  end

  def rotate_char(<<char>>, shift) do
    base = if char >= ?a and char <= ?z, do: ?a, else: ?A
    offset = char - base
    rotated = rem(offset + shift, 26)
    <<base + rotated>>
  end
end
