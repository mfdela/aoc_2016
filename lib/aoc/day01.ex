defmodule Aoc.Day01 do
  def part1(args) do
    sequence =
      args
      |> parse_input()

    end_square =
      move({Complex.new(0, 1), Complex.new(0, 0)}, MapSet.new(), false, sequence)

    abs(Complex.real(end_square)) + abs(Complex.imag(end_square))
  end

  def part2(args) do
    sequence =
      args
      |> parse_input()

    end_square = move({Complex.new(0, 1), Complex.new(0, 0)}, MapSet.new(), true, sequence)
    abs(Complex.real(end_square)) + abs(Complex.imag(end_square))
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(", ", trim: true)
    |> Enum.map(fn dir ->
      [dir, steps] = Regex.run(~r/(\w)(\d+)/, dir, capture: :all_but_first)
      {dir, String.to_integer(steps)}
    end)
  end

  def move({_base, end_square}, _visited, _twice, []), do: end_square

  def move({base, square}, visited, twice, [{dir, steps} | rest]) do
    next_base =
      case dir do
        "R" -> Complex.multiply(base, Complex.new(0, -1))
        "L" -> Complex.multiply(base, Complex.new(0, 1))
      end

    # Track all intermediate positions in taxicab geometry
    {final_square, updated_visited, found_twice} =
      Enum.reduce_while(1..steps, {square, visited, nil}, fn _step,
                                                             {current_square, current_visited, _} ->
        next_pos = Complex.add(current_square, next_base)

        if twice && MapSet.member?(current_visited, next_pos) do
          # Found first location visited twice
          {:halt, {next_pos, current_visited, next_pos}}
        else
          {:cont, {next_pos, MapSet.put(current_visited, next_pos), nil}}
        end
      end)

    case found_twice do
      nil -> move({next_base, final_square}, updated_visited, twice, rest)
      location -> location
    end
  end
end
