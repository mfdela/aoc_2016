defmodule Aoc.Day20 do
  def part1(args) do
    args
    |> parse_input()
    |> merge_ranges()
    |> first_allowed_ip()
  end

  def part2(args) do
    args
    |> parse_input()
    |> merge_ranges()
    |> count_allowed_ips()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.map(fn [start, end_] -> {String.to_integer(start), String.to_integer(end_)} end)
  end

  def merge_ranges(ranges) do
    ranges
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.reduce([], fn {start, end_}, acc ->
      case acc do
        [] ->
          [{start, end_}]

        [{prev_start, prev_end} | rest] ->
          if start <= prev_end + 1 do
            # Ranges overlap or are adjacent, merge them
            [{prev_start, max(end_, prev_end)} | rest]
          else
            # No overlap, add as new range
            [{start, end_} | acc]
          end
      end
    end)
    |> Enum.reverse()
  end

  def first_allowed_ip([{_first_start, first_end} | _rest]), do: first_end + 1

  def count_allowed_ips([{_first_start, first_end} | rest]) do
    rest
    |> Enum.reduce({0, first_end}, fn {start, end_}, {count, prev_end} ->
      {count + (start - prev_end - 1), end_}
    end)
    |> elem(0)
  end
end
