defmodule Aoc.Day08 do
  def part1(args, rows \\ 6, cols \\ 50) do
    args
    |> parse_input()
    |> execute_instructions(rows, cols)
    |> count_pixels()
  end

  def part2(args, rows \\ 6, cols \\ 50) do
    args
    |> parse_input()
    |> execute_instructions(rows, cols)
    |> print_screen(rows, cols)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    case line do
      <<"rect ", dimensions::binary>> ->
        [width, height] = String.split(dimensions, "x")
        {:rect, [String.to_integer(width), String.to_integer(height)]}

      <<"rotate column x=", rest::binary>> ->
        [column_str, amount_str] = String.split(rest, " by ")
        {:rotate_column, [String.to_integer(column_str), String.to_integer(amount_str)]}

      <<"rotate row y=", rest::binary>> ->
        [row_str, amount_str] = String.split(rest, " by ")
        {:rotate_row, [String.to_integer(row_str), String.to_integer(amount_str)]}
    end
  end

  def execute_instructions(instructions, rows \\ 6, cols \\ 50) do
    instructions
    |> Enum.reduce(%{}, &execute_instruction(&1, &2, rows, cols))
  end

  def execute_instruction({:rect, [width, height]}, screen, _rows, _cols) do
    for row <- 0..(height - 1),
        col <- 0..(width - 1),
        into: screen,
        do: {{row, col}, true}
  end

  def execute_instruction({:rotate_column, [column, amount]}, screen, rows, _cols) do
    for row <- 0..(rows - 1), into: screen do
      new_pixel = {rem(row + amount, rows), column}
      old_value = screen[{row, column}] || false
      {new_pixel, old_value}
    end
  end

  def execute_instruction({:rotate_row, [row, amount]}, screen, _rows, cols) do
    for col <- 0..(cols - 1), into: screen do
      new_pixel = {row, rem(col + amount, cols)}
      old_value = screen[{row, col}] || false
      {new_pixel, old_value}
    end
  end

  def print_screen(map, rows, cols) do
    for r <- 0..(rows - 1) do
      for c <- 0..(cols - 1) do
        if Map.get(map, {r, c}, false), do: "#", else: "."
      end
      |> Enum.join()
      |> IO.puts()
    end
  end

  def count_pixels(map) do
    map
    |> Map.values()
    |> Enum.count(& &1)
  end
end
