defmodule Aoc.Day07 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.filter(&is_valid/1)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.filter(&is_valid2/1)
    |> Enum.count()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn string ->
      {string
       |> String.replace(~r/\[[^\]]*\]/, " ")
       |> then(&Regex.scan(~r/(\w+)/, &1, capture: :all_but_first))
       |> List.flatten(),
       Regex.scan(~r/\[(\w+)\]/, string, capture: :all_but_first)
       |> List.flatten()}
    end)
  end

  def is_valid({outer, inner}) do
    Enum.any?(outer, &Regex.match?(~r/(\w)(?!\1)(\w)\2\1/, &1)) &&
      !Enum.any?(inner, &Regex.match?(~r/(\w)(?!\1)(\w)\2\1/, &1))
  end

  def is_valid2({outer, inner}) do
    for o <- outer, reduce: false do
      found ->
        for xyx <-
              Regex.scan(~r/(?=((\w)(?!\2)(\w)\2))/, o, capture: :all_but_first)
              |> Enum.map(&hd/1),
            reduce: found do
          inner_found ->
            [x, y, x] = xyx |> String.graphemes()

            for i <- inner, reduce: inner_found do
              last_found ->
                case String.contains?(i, Enum.join([y, x, y])) do
                  false -> last_found
                  true -> true
                end
            end
        end
    end
  end
end
