defmodule Aoc.Day18 do
  def part1(args, times \\ 40) do
    # {first_row, indexes} =
    #   parse_input(args)
    # iterate_rows(first_row, indexes, times)
    # |> elem(1)

    # This is 4x faster
    {first_row, size} = parse_input_bits(args)
    iterate_rows_bits(first_row, size, times) |> elem(1)
  end

  def part2(args, times \\ 400_000) do
    # {first_row, indexes} =
    #   parse_input(args)
    # iterate_rows(first_row, indexes, times)
    # |> elem(1)

    # This is 4x faster
    {first_row, size} = parse_input_bits(args)
    iterate_rows_bits(first_row, size, times) |> elem(1)
  end

  def parse_input(input) do
    map =
      input
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, index} -> {index, char} end)
      |> Map.new()

    indexes = Map.keys(map) |> Enum.sort()
    {map, indexes}
  end

  # True bitstring version - 0 for safe (.), 1 for trap (^)
  def parse_input_bits(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.reduce({<<>>, 0}, fn
      ".", {bits, count} -> {<<bits::bitstring, 0::1>>, count + 1}
      "^", {bits, count} -> {<<bits::bitstring, 1::1>>, count + 1}
    end)
  end

  def new_tile("^", "^", "."), do: "^"
  def new_tile(".", "^", "^"), do: "^"
  def new_tile("^", ".", "."), do: "^"
  def new_tile(".", ".", "^"), do: "^"
  def new_tile(_left, _center, _right), do: "."

  # True bitstring version - 0 for safe, 1 for trap
  # Trap patterns: ^^., .^^, ^.., ..^
  def new_tile_bits(1, 1, 0), do: 1
  def new_tile_bits(0, 1, 1), do: 1
  def new_tile_bits(1, 0, 0), do: 1
  def new_tile_bits(0, 0, 1), do: 1
  def new_tile_bits(_left, _center, _right), do: 0

  def new_row(row, indexes) do
    # first element
    new_row = %{0 => new_tile(".", row[0], row[1])}
    last_index = length(indexes) - 1

    Enum.chunk_every(indexes, 3, 1, :discard)
    |> Enum.map(fn [left, center, right] ->
      {center, new_tile(row[left], row[center], row[right])}
    end)
    |> Map.new()
    |> Map.merge(new_row)
    |> Map.put(last_index, new_tile(row[last_index - 1], row[last_index], "."))
  end

  def new_row_bits(row, size) do
    new_row_bits(row, size, 0, <<>>)
  end

  def new_row_bits(_row, size, size, acc), do: acc

  def new_row_bits(row, size, 0, acc) do
    # First position: left is 0
    <<center::1, right::1, _::bitstring>> = row
    tile = new_tile_bits(0, center, right)
    new_row_bits(row, size, 1, <<acc::bitstring, tile::1>>)
  end

  def new_row_bits(row, size, pos, acc) when pos == size - 1 do
    # Last position: right is 0
    <<_::size(pos - 1), left::1, center::1>> = row
    tile = new_tile_bits(left, center, 0)
    new_row_bits(row, size, pos + 1, <<acc::bitstring, tile::1>>)
  end

  def new_row_bits(row, size, pos, acc) do
    # Middle positions: extract left, center, right in one match
    <<_::size(pos - 1), left::1, center::1, right::1, _::bitstring>> = row
    tile = new_tile_bits(left, center, right)
    new_row_bits(row, size, pos + 1, <<acc::bitstring, tile::1>>)
  end

  def count_safes(row) do
    row
    |> Map.values()
    |> Enum.count(&(&1 == "."))
  end

  def count_safes_bits(row, size) do
    # Pad to byte boundary for popcount
    padding = rem(8 - rem(size, 8), 8)
    padded = if padding == 0, do: row, else: <<row::bitstring, 0::size(padding)>>

    # Count 1s (traps) directly on the binary
    trap_count = ExPopcount.popcount(padded)

    # Safe tiles = total - traps (0 = safe, 1 = trap)
    size - trap_count
  end

  def iterate_rows(row, indexes, times) do
    Enum.reduce(1..(times - 1), {row, 0}, fn _r, {row, count} ->
      {new_row(row, indexes), count + count_safes(row)}
    end)
    |> then(fn {final_row, count} -> {final_row, count + count_safes(final_row)} end)
  end

  def iterate_rows_bits(row, size, times) do
    Enum.reduce(1..(times - 1), {row, 0}, fn _r, {row, count} ->
      {new_row_bits(row, size), count + count_safes_bits(row, size)}
    end)
    |> then(fn {final_row, count} -> {final_row, count + count_safes_bits(final_row, size)} end)
  end
end
