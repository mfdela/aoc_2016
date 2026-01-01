defmodule Elixir.Mix.Tasks.D13.P2 do
  use Mix.Task

  import Elixir.Aoc.Day13

  @shortdoc "Day 13 Part 2"
  def run(args) do
    input = 1350

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
