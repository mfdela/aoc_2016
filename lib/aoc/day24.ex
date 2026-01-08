defmodule Aoc.Day24 do
  def part1(args) do
    grid = parse_input(args)

    # Find all numbered locations
    locations = find_locations(grid)

    # Build distance matrix using BFS
    distances = build_distance_matrix(grid, locations)

    # Solve TSP starting from 0
    other_locations = Map.keys(locations) -- [0]

    permutations(other_locations)
    |> Enum.map(fn path ->
      total_distance([0 | path], distances)
    end)
    |> Enum.min()
  end

  def part2(args) do
    grid = parse_input(args)

    # Find all numbered locations
    locations = find_locations(grid)

    # Build distance matrix using BFS
    distances = build_distance_matrix(grid, locations)

    # Solve TSP starting from 0 and returning to 0
    other_locations = Map.keys(locations) -- [0]

    permutations(other_locations)
    |> Enum.map(fn path ->
      # Add return to 0 at the end
      full_path = [0 | path] ++ [0]
      total_distance(full_path, distances)
    end)
    |> Enum.min()
  end

  defp find_locations(grid) do
    grid
    |> Enum.filter(fn {_pos, val} -> val =~ ~r/\d/ end)
    |> Enum.map(fn {pos, val} -> {String.to_integer(val), pos} end)
    |> Map.new()
  end

  defp build_distance_matrix(grid, locations) do
    for {from_num, from_pos} <- locations,
        {to_num, to_pos} <- locations,
        from_num != to_num,
        into: %{} do
      {{from_num, to_num}, bfs(grid, from_pos, to_pos)}
    end
  end

  defp bfs(grid, start, goal) do
    queue = :queue.from_list([{start, 0}])
    visited = MapSet.new([start])
    bfs_loop(grid, queue, visited, goal)
  end

  defp bfs_loop(grid, queue, visited, goal) do
    case :queue.out(queue) do
      {{:value, {pos, dist}}, new_queue} ->
        if pos == goal do
          dist
        else
          {new_queue, new_visited} =
            expand_neighbors(grid, pos, dist, new_queue, visited)

          bfs_loop(grid, new_queue, new_visited, goal)
        end

      {:empty, _} ->
        :infinity
    end
  end

  defp expand_neighbors(grid, {r, c}, dist, queue, visited) do
    [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}]
    |> Enum.reduce({queue, visited}, fn pos, {q, v} ->
      if Map.get(grid, pos) != "#" and not MapSet.member?(v, pos) do
        {:queue.in({pos, dist + 1}, q), MapSet.put(v, pos)}
      else
        {q, v}
      end
    end)
  end

  defp total_distance([_], _distances), do: 0

  defp total_distance([from | [to | _] = rest], distances) do
    distances[{from, to}] + total_distance(rest, distances)
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for elem <- list,
        rest <- permutations(list -- [elem]) do
      [elem | rest]
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {val, c} -> {{r, c}, val} end)
    end)
    |> Map.new()
  end
end
