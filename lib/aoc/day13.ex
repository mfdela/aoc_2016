defmodule Aoc.Day13 do
  def part1(args) do
    favourite_number = parse_input(args)
    goal_fn = fn {x, y}, _ -> {:halt, x == 31 and y == 39} end
    {:found, _visited, distances} = bfs(1, 1, favourite_number, goal_fn)
    Map.get(distances, {31, 39})
  end

  def part2(args) do
    favourite_number = parse_input(args)
    goal_fn = fn _pos, dist -> {:cont, dist <= 50} end
    {:done, _visited, distances} = bfs(1, 1, favourite_number, goal_fn)
    # number of reachable positions within 50 steps
    distances
    |> Enum.filter(fn {_pos, dist} -> dist <= 50 end)
    |> Enum.count()
  end

  def parse_input(input) do
    input
  end

  def is_open?(x, y, favourite_number) do
    x >= 0 and y >= 0 and
      rem(count_ones(x * x + 3 * x + 2 * x * y + y + y * y + favourite_number), 2) == 0
  end

  def count_ones(n), do: ExPopcount.popcount_integer(n)

  def get_neighbours(x, y) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  defp expand_neighbours(x, y, favourite_number, dist, queue, visited, distances) do
    neighbours = get_neighbours(x, y)

    new_positions =
      neighbours
      |> Enum.filter(fn {nx, ny} ->
        {nx, ny} not in visited and
          nx >= 0 and ny >= 0 and
          is_open?(nx, ny, favourite_number)
      end)

    new_visited = Enum.reduce(new_positions, visited, &MapSet.put(&2, &1))

    new_distances =
      Enum.reduce(new_positions, distances, fn pos, acc ->
        Map.put(acc, pos, dist + 1)
      end)

    new_queue =
      Enum.reduce(new_positions, queue, fn pos, q ->
        :queue.in({pos, dist + 1}, q)
      end)

    {new_queue, new_visited, new_distances}
  end

  def bfs(start_x, start_y, favourite_number, goal_fn) do
    initial_state = {start_x, start_y}
    queue = :queue.from_list([{initial_state, 0}])
    visited = MapSet.new([initial_state])
    distances = %{{start_x, start_y} => 0}

    bfs_loop(queue, visited, distances, favourite_number, goal_fn)
  end

  def bfs_loop(queue, visited, distances, favourite_number, goal_fn) do
    case :queue.out(queue) do
      # Queue is empty - search complete
      {:empty, _} ->
        {:done, visited, distances}

      # Process next position
      {{:value, {{x, y}, dist}}, remaining_queue} ->
        # Check if we found the goal
        goal = goal_fn.({x, y}, dist)

        case goal do
          {:halt, true} ->
            {:found, visited, distances}

          g when g in [{:cont, true}, {:halt, false}] ->
            {new_queue, new_visited, new_distances} =
              expand_neighbours(x, y, favourite_number, dist, remaining_queue, visited, distances)

            bfs_loop(new_queue, new_visited, new_distances, favourite_number, goal_fn)

          {:cont, false} ->
            bfs_loop(remaining_queue, visited, distances, favourite_number, goal_fn)
        end
    end
  end
end
