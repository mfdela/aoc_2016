defmodule Aoc.Day14 do
  def part1(args) do
    # On my laptop, this takes about 5 seconds
    # args
    # |> find_64th_key()
    # |> List.last()

    # Heuristically, we can use a cache of 24000 hashes to speed up the process
    hash_cache =
      args
      |> generate_blocks_hash(24000)

    find_64th_key(args, 1, hash_cache)
    |> List.last()
  end

  def part2(args) do
    # On my laptop, this takes about 30 seconds
    # args
    # |> find_64th_key(2017)
    # |> List.last()

    # Heuristically, we can use a cache of 24000 hashes to speed up the process
    # This now takes about 15 seconds
    hash_cache =
      args
      |> generate_blocks_hash(24000, 2017)

    find_64th_key(args, 2017, hash_cache)
    |> List.last()
  end

  def hash(input, stretching) do
    Enum.reduce(1..stretching, input, fn _, acc ->
      :crypto.hash(:md5, acc) |> Base.encode16(case: :lower)
    end)
  end

  def find_first_key(input, index, repetitions, cache, stretching) do
    string_to_hash = input <> Integer.to_string(index)

    hash = Map.get(cache, string_to_hash, false) || hash(string_to_hash, stretching)

    case Regex.run(~r/(\w)\1{#{repetitions - 1}}/, hash, capture: :all_but_first) do
      nil ->
        find_first_key(
          input,
          index + 1,
          repetitions,
          Map.put(cache, string_to_hash, hash),
          stretching
        )

      [val] ->
        # IO.inspect(index, label: "found 3 #{val} #{hash}")
        {hash, index, Map.put(cache, string_to_hash, hash), val}
    end
  end

  def find_in_next_thousand(input, index, repetitions, matching_char, cache, stretching) do
    Enum.reduce_while(
      index..(index + 999),
      {:not_found, cache},
      fn next_index, {_found, cache} ->
        string_to_hash = input <> Integer.to_string(next_index)
        hash = Map.get(cache, string_to_hash, false) || hash(string_to_hash, stretching)

        case String.match?(hash, ~r/(#{matching_char})\1{#{repetitions - 1}}/) do
          false -> {:cont, {:not_found, Map.put(cache, string_to_hash, hash)}}
          true -> {:halt, {:found, Map.put(cache, string_to_hash, hash)}}
        end
      end
    )
  end

  def find_next_key(input, index, cache, stretching) do
    {_first_hash, start_index, updated_cache, matching_char} =
      find_first_key(input, index, 3, cache, stretching)

    case find_in_next_thousand(
           input,
           start_index + 1,
           5,
           matching_char,
           updated_cache,
           stretching
         ) do
      {:not_found, last_cache} -> find_next_key(input, start_index + 1, last_cache, stretching)
      {:found, last_cache} -> {start_index, last_cache}
    end
  end

  def find_64th_key(input, stretching \\ 1, cache \\ %{}) do
    Stream.iterate({0, nil, cache}, fn {index, _last_index, next_cache} ->
      {found_index, found_cache} = find_next_key(input, index, next_cache, stretching)
      {found_index + 1, found_index, found_cache}
    end)
    |> Enum.take(65)
    |> Enum.map(&elem(&1, 1))
  end

  def generate_blocks_hash(input, size, stretching \\ 1) do
    parallelism = System.schedulers_online()
    parallel_tasks_chunk = div(size, parallelism)

    Enum.map(
      0..(parallelism - 1),
      fn i ->
        Task.async(fn ->
          generate_hash(
            input,
            i * parallel_tasks_chunk,
            (i + 1) * parallel_tasks_chunk - 1,
            stretching
          )
        end)
      end
    )
    |> Enum.map(&Task.await(&1, 60000))
    |> List.flatten()
    |> Enum.reduce(%{}, &Map.merge(&2, &1))
  end

  def generate_hash(input, start_index, end_index, stretching) do
    Enum.reduce(start_index..end_index, %{}, fn i, acc ->
      string_to_hash = input <> Integer.to_string(i)
      Map.put(acc, string_to_hash, hash(string_to_hash, stretching))
    end)
  end
end
