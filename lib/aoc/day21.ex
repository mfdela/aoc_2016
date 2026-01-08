defmodule Aoc.Day21 do
  def part1(args, string \\ "abcdefgh") do
    args
    |> parse_input()
    |> Enum.reduce(String.graphemes(string), &apply_instruction/2)
    |> Enum.join()
  end

  def part2(args, string \\ "fbgdceah") do
    args
    |> parse_input()
    |> Enum.reverse()
    |> Enum.reduce(String.graphemes(string), &reverse_instruction/2)
    |> Enum.join()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(<<"swap position ", a::binary-size(1), " with position ", b::binary-size(1)>>) do
    {:swap_position, String.to_integer(a), String.to_integer(b)}
  end

  def parse_line(<<"swap letter ", a::binary-size(1), " with letter ", b::binary-size(1)>>) do
    {:swap_letters, a, b}
  end

  def parse_line(<<"reverse positions ", a::binary-size(1), " through ", b::binary-size(1)>>) do
    {:reverse_positions, String.to_integer(a), String.to_integer(b)}
  end

  def parse_line(<<"rotate left ", a::binary-size(1), _rest::binary>>) do
    {:rotate_left, String.to_integer(a)}
  end

  def parse_line(<<"rotate right ", a::binary-size(1), _rest::binary>>) do
    {:rotate_right, String.to_integer(a)}
  end

  def parse_line(<<"rotate based on position of letter ", a::binary-size(1)>>) do
    {:rotate_based_on_position, a}
  end

  def parse_line(<<"move position ", a::binary-size(1), " to position ", b::binary-size(1)>>) do
    {:move_position, String.to_integer(a), String.to_integer(b)}
  end

  def apply_instruction({:swap_position, pos1, pos2}, string) do
    string
    |> List.replace_at(pos1, Enum.at(string, pos2))
    |> List.replace_at(pos2, Enum.at(string, pos1))
  end

  def apply_instruction({:swap_letters, a, b}, string) do
    pos1 = Enum.find_index(string, &(&1 == a))
    pos2 = Enum.find_index(string, &(&1 == b))

    string
    |> List.replace_at(pos1, Enum.at(string, pos2))
    |> List.replace_at(pos2, Enum.at(string, pos1))
  end

  def apply_instruction({:reverse_positions, a, b}, string) do
    substring =
      string
      |> Enum.slice(a, b - a + 1)
      |> Enum.reverse()

    Enum.concat(Enum.slice(string, 0, a), substring)
    |> Enum.concat(Enum.slice(string, b + 1, length(string) - b - 1))
  end

  def apply_instruction({:rotate_left, a}, string) do
    string
    |> Enum.slice(a..-1//1)
    |> Enum.concat(Enum.slice(string, 0, a))
  end

  def apply_instruction({:rotate_right, 0}, string), do: string

  def apply_instruction({:rotate_right, a}, string) do
    string
    |> Enum.slice(-a..-1//1)
    |> Enum.concat(Enum.slice(string, 0, length(string) - a))
  end

  def apply_instruction({:rotate_based_on_position, letter}, string) do
    index = Enum.find_index(string, &(&1 == letter))
    offset = index + 1 + if index >= 4, do: 1, else: 0
    apply_instruction({:rotate_right, rem(offset, length(string))}, string)
  end

  def apply_instruction({:move_position, from, to}, string) do
    val = Enum.at(string, from)

    string
    |> List.delete_at(from)
    |> List.insert_at(to, val)
  end

  # Reverse operations for part 2
  # swap_position and swap_letters are self-inverses
  def reverse_instruction({:swap_position, pos1, pos2}, string) do
    apply_instruction({:swap_position, pos1, pos2}, string)
  end

  def reverse_instruction({:swap_letters, a, b}, string) do
    apply_instruction({:swap_letters, a, b}, string)
  end

  # reverse_positions is also self-inverse
  def reverse_instruction({:reverse_positions, a, b}, string) do
    apply_instruction({:reverse_positions, a, b}, string)
  end

  # rotate_left <-> rotate_right
  def reverse_instruction({:rotate_left, a}, string) do
    apply_instruction({:rotate_right, a}, string)
  end

  def reverse_instruction({:rotate_right, a}, string) do
    apply_instruction({:rotate_left, a}, string)
  end

  # move_position reverses from/to
  def reverse_instruction({:move_position, from, to}, string) do
    apply_instruction({:move_position, to, from}, string)
  end

  # rotate_based_on_position is tricky - need to find the reverse mapping
  def reverse_instruction({:rotate_based_on_position, letter}, string) do
    # Try each possible rotation until we find which one would produce current state
    len = length(string)

    result =
      Enum.find_value(0..(len - 1), fn offset ->
        test = apply_instruction({:rotate_left, offset}, string)
        index = Enum.find_index(test, &(&1 == letter))
        expected_offset = index + 1 + if index >= 4, do: 1, else: 0

        if rem(expected_offset, len) == offset do
          test
        else
          nil
        end
      end)

    result || string
  end
end
