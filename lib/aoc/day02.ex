defmodule Aoc.Day02 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.reduce({{1, 1}, []}, fn sequence, {start_key, numbers} ->
      new_key = sequence_to_number(sequence, start_key, &move/2)
      {new_key, numbers ++ [key_to_number(new_key)]}
    end)
    |> elem(1)
    |> Enum.join()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.reduce({{0, 2}, []}, fn sequence, {start_key, numbers} ->
      new_key =
        sequence_to_number(sequence, start_key, &move_diamond/2)

      {new_key, numbers ++ [key_to_number2(new_key)]}
    end)
    |> elem(1)
    |> Enum.join()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def move(direction, {x, y}) do
    case direction do
      "U" -> {x, max(y - 1, 0)}
      "D" -> {x, min(y + 1, 2)}
      "L" -> {max(x - 1, 0), y}
      "R" -> {min(x + 1, 2), y}
    end
  end

  def move_diamond(direction, {x, y}) do
    new_pos =
      case direction do
        "U" -> {x, y - 1}
        "D" -> {x, y + 1}
        "L" -> {x - 1, y}
        "R" -> {x + 1, y}
      end

    if valid_diamond_keypad_position?(new_pos), do: new_pos, else: {x, y}
  end

  # Check if a position is valid on the diamond keypad
  def valid_diamond_keypad_position?({x, y}) do
    case y do
      0 -> x == 2
      1 -> x in 1..3
      2 -> x in 0..4
      3 -> x in 1..3
      4 -> x == 2
      _ -> false
    end
  end

  def key_to_number({x, y}) do
    x + y * 3 + 1
  end

  def key_to_number2({x, y}) do
    case y do
      0 -> if x == 2, do: 1, else: nil
      1 -> if x in 1..3, do: x + 1, else: nil
      2 -> if x in 0..4, do: x + 5, else: nil
      3 -> if x in 1..3, do: List.to_string([x + 9 + 55]), else: nil
      4 -> if x == 2, do: "D", else: nil
      _ -> nil
    end
  end

  def sequence_to_number(sequence, start_key, move_fn) do
    sequence
    |> Enum.reduce(start_key, &move_fn.(&1, &2))
  end
end
