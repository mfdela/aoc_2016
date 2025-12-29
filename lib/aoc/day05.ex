defmodule Aoc.Day05 do
  def part1(args) do
    args
    |> String.trim()
    |> find_passwords()
    |> Enum.take(8)
    |> Enum.map(fn {hash, _} -> String.at(hash, 5) end)
    |> Enum.join()
  end

  def part2(args) do
    password_map =
      args
      |> String.trim()
      |> find_passwords()
      |> Stream.filter(fn {hash, _} ->
        c = String.at(hash, 5)
        <<codepoint::utf8>> = c
        codepoint >= ?0 and codepoint <= ?7
      end)
      |> Enum.reduce_while(%{}, fn {hash, _}, acc ->
        new_map = Map.put_new(acc, String.at(hash, 5), String.at(hash, 6))

        case map_size(acc) == 8 do
          true -> {:halt, new_map}
          false -> {:cont, new_map}
        end
      end)

    Enum.map(?0..?7, &password_map[<<&1::utf8>>])
    |> Enum.join()
  end

  def next_hash(input, index) do
    hash =
      :crypto.hash(:md5, input <> Integer.to_string(index))
      |> Base.encode16(case: :lower)

    case String.starts_with?(hash, "00000") do
      true -> {hash, index}
      false -> next_hash(input, index + 1)
    end
  end

  def find_passwords(input) do
    Stream.iterate({input, 0}, fn {_, next_index} ->
      next_hash(input, next_index + 1)
    end)
    |> Stream.drop(1)
  end
end
