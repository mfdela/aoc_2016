defmodule Aoc.Day16 do
  import Bitwise

  def part1(args, size \\ 272) do
    args
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> generate_fill(size)
    |> generate_checksum()
    |> Enum.join()
  end

  def part2(args, size \\ 35_651_584) do
    args
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> generate_fill(size)
    |> generate_checksum()
    |> Enum.join()
  end

  def flip_bits(list) do
    list
    |> Enum.map(&bxor(1, &1))
  end

  def generate_step(a) do
    # Call the data you have at this point "a".
    # Make a copy of "a"; call this copy "b".
    # Reverse the order of the characters in "b".
    # In "b", replace all instances of 0 with 1 and all 1s with 0.
    b = a |> Enum.reverse() |> flip_bits()
    # The resulting data is "a", then a single 0, then "b".
    a ++ [0] ++ b
  end

  def generate_fill(a, length) do
    new_a =
      a
      |> generate_step()

    case length(new_a) >= length do
      true -> Enum.take(new_a, length)
      false -> generate_fill(new_a, length)
    end
  end

  def generate_checksum(a) do
    checksum =
      a
      |> Enum.chunk_every(2)
      |> Enum.map(fn [x, y] -> if x == y, do: 1, else: 0 end)

    case rem(length(checksum), 2) == 0 do
      false -> checksum
      true -> generate_checksum(checksum)
    end
  end
end
