defmodule Aoc.Day09 do
  def part1(args) do
    args
    |> parse_input()
    |> decompress(false)
  end

  def part2(args) do
    args
    |> parse_input()
    |> decompress(true)
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.replace(~r/\s/, "")
  end

  def decompress("", _part2), do: 0

  def decompress("(" <> rest, part2) do
    # Parse the marker (AxB)
    [marker, remaining] = String.split(rest, ")", parts: 2)

    [chars, times] =
      marker
      |> String.split("x")
      |> Enum.map(&String.to_integer/1)

    # Get the data section
    {data, after_data} = String.split_at(remaining, chars)

    data_length =
      case part2 do
        # Skip the next 'chars' characters (they contribute chars * times to length)
        false -> chars
        # **Recursively** decompress the data section if part2 is true
        true -> decompress(data, part2)
      end

    # This section contributes data_length * times, then continue with rest
    data_length * times + decompress(after_data, part2)
  end

  def decompress(<<_char::utf8, rest::binary>>, part2) do
    # Regular character contributes 1
    1 + decompress(rest, part2)
  end
end
