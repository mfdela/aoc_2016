defmodule Aoc.Day17 do
  def part1(args) do
    find_all_paths({0, 0}, {3, 3}, args, :min)
    |> Enum.join()
  end

  def part2(args) do
    find_all_paths({0, 0}, {3, 3}, args, :max)
    |> Enum.count()
  end

  def doors_state(input) do
    hash =
      :crypto.hash(:md5, input)
      |> Base.encode16(case: :lower)
      |> String.slice(0..3)
      |> String.graphemes()
      |> Enum.map(&open_close/1)

    Enum.zip(["U", "D", "L", "R"], hash)
    |> Map.new()
  end

  def open_close(char) do
    cond do
      char in ["b", "c", "d", "e", "f"] -> :open
      true -> :closed
    end
  end

  def is_wall?({r, c}) do
    r < 0 || c < 0 || c > 3 || r > 3
  end

  def get_open({r, c}, doors) do
    [{{r - 1, c}, "U"}, {{r + 1, c}, "D"}, {{r, c - 1}, "L"}, {{r, c + 1}, "R"}]
    |> Enum.filter(&(!is_wall?(elem(&1, 0))))
    |> Enum.filter(&(Map.get(doors, elem(&1, 1)) == :open))
  end

  def find_all_paths(start, target, seed, type) do
    # Queue stores {position, path_taken}
    # Start with initial position and path containing just the start
    initial_state = {start, []}
    queue = :queue.from_list([initial_state])

    bfs(queue, target, seed, [], type, nil)
  end

  defp bfs(queue, target, seed, min_max_path, type, min_max_length) do
    case :queue.out(queue) do
      {{:value, {current, path}}, rest_queue} ->
        # IO.inspect({current, path}, label: "Current State")

        if current == target do
          # Found a path to target
          # Continue searching for other paths of same length
          path_length = length(path)

          {new_min_max, new_path} =
            update_min_max(type, path_length, min_max_length, path, min_max_path)

          bfs(rest_queue, target, seed, new_path, type, new_min_max)
        else
          # Generate neighbors and add to queue
          passcode = seed <> Enum.join(path, "")
          doors_state = doors_state(passcode)

          open_doors =
            get_open(current, doors_state)

          # Add new states to queue
          new_queue =
            Enum.reduce(open_doors, rest_queue, fn {neighbour, direction}, q ->
              case (type == :min and length(path) < min_max_length) or is_nil(min_max_length) or
                     type == :max do
                false -> q
                true -> :queue.in({neighbour, path ++ [direction]}, q)
              end
            end)

          bfs(new_queue, target, seed, min_max_path, type, min_max_length)
        end

      {:empty, _} ->
        # Queue is empty, return min or max path
        min_max_path
    end
  end

  def update_min_max(_type, new_length, nil, new_path, _old_path), do: {new_length, new_path}

  def update_min_max(:min, new_length, min_length, new_path, _old_path)
      when new_length < min_length, do: {new_length, new_path}

  def update_min_max(:max, new_length, max_length, new_path, _old_path)
      when new_length > max_length, do: {new_length, new_path}

  def update_min_max(_type, _new_length, old_length, _new_path, old_path),
    do: {old_length, old_path}
end
