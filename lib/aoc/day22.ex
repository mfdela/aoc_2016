defmodule Aoc.Day22 do
  def part1(args) do
    nodes = parse_input(args)

    # Count viable pairs: (A, B) where A is not empty, A != B, and A's used fits in B's avail
    for {xa, ya, _size_a, used_a, _avail_a} <- nodes,
        {xb, yb, _size_b, _used_b, avail_b} <- nodes,
        used_a > 0,
        {xa, ya} != {xb, yb},
        used_a <= avail_b,
        reduce: 0 do
      acc -> acc + 1
    end
  end

  def part2(args) do
    nodes = parse_input(args)
    visualize_grid(nodes)
  end

  def visualize_grid(nodes) do
    # Find grid dimensions
    max_x = Enum.map(nodes, fn {x, _, _, _, _} -> x end) |> Enum.max()
    max_y = Enum.map(nodes, fn {_, y, _, _, _} -> y end) |> Enum.max()

    # Create a map for quick lookup
    node_map = Map.new(nodes, fn {x, y, size, used, avail} -> {{x, y}, {size, used, avail}} end)

    IO.puts("\nGrid visualization:")
    IO.puts("G = Goal data (top right), _ = Empty, # = Wall (>100T used), . = Normal")
    IO.puts("")

    for y <- 0..max_y do
      for x <- 0..max_x do
        {_size, used, _avail} = Map.get(node_map, {x, y})

        char =
          cond do
            # Goal data location
            x == max_x and y == 0 -> "G"
            # Empty node
            used == 0 -> "_"
            # Wall (very full nodes)
            used > 100 -> "#"
            # Normal node
            true -> "."
          end

        IO.write(char)
      end

      IO.puts("")
    end

    # Find the empty node and goal
    {empty_x, empty_y, _, _, _} = Enum.find(nodes, fn {_, _, _, used, _} -> used == 0 end)
    goal_x = max_x
    goal_y = 0

    IO.puts("\nEmpty node at: (#{empty_x}, #{empty_y})")
    IO.puts("Goal data at: (#{goal_x}, #{goal_y})")
    IO.puts("Target: (0, 0)")

    # Find the wall - nodes with > 100T used
    wall_nodes = Enum.filter(nodes, fn {_, _, _, used, _} -> used > 100 end)
    wall_min_x = Enum.map(wall_nodes, fn {x, _, _, _, _} -> x end) |> Enum.min()

    IO.puts("\nWall starts at x=#{wall_min_x}")

    # Steps calculation:
    # 1. Move empty from (35,27) up to row 0: 27 moves
    # 2. Move empty left to just before wall: (35 - wall_min_x + 1) moves
    # 3. Move empty around wall (up is blocked, so go left then up): wall_min_x - 1 moves left, then 1 up to wall row, then 1 left past wall = wall not in row 0, so just move left
    # Actually simpler: empty at (35, 27), needs to get to (34, 0) to be left of goal
    #   - Up from 27 to 0 if no wall: 27 moves
    #   - But wall is in the way at row 17
    #   - So: up to row 17: (27-17) = 10, left to x=(wall_min_x-1): (35-(wall_min_x-1)) moves, up to 0: 17 moves, right to 34: distance

    # Simpler approach: Manhattan distance but around the wall
    # Empty at (35, 27) -> needs to reach (goal_x - 1, 0) = (34, 0)
    # Wall at row 17, columns from wall_min_x to end

    # Steps to move empty to left of goal:
    # From (35, 27): up (27-17=10), left to (wall_min_x-1), up (17), right to (goal_x-1)
    steps_up_to_wall = 27 - 17
    steps_left_around_wall = 35 - (wall_min_x - 1)
    steps_up_past_wall = 17
    steps_right_to_goal = goal_x - 1 - (wall_min_x - 1)

    steps_to_goal =
      steps_up_to_wall + steps_left_around_wall + steps_up_past_wall + steps_right_to_goal

    # Once empty is at (goal_x-1, 0), we need to slide goal left to (0, 0)
    # Each position moved left requires 5 moves (move empty around to push from right)
    # Except the first move which is just 1
    steps_to_slide = 1 + (goal_x - 1) * 5

    total = steps_to_goal + steps_to_slide

    IO.puts("\nCalculation:")
    IO.puts("Steps to move empty to (#{goal_x - 1}, 0):")
    IO.puts("  Up to wall row: #{steps_up_to_wall}")
    IO.puts("  Left around wall: #{steps_left_around_wall}")
    IO.puts("  Up past wall: #{steps_up_past_wall}")
    IO.puts("  Right to goal: #{steps_right_to_goal}")
    IO.puts("  Subtotal: #{steps_to_goal}")
    IO.puts("\nSteps to slide goal from (#{goal_x},0) to (0,0): #{steps_to_slide}")
    IO.puts("  (1 initial move + #{goal_x - 1} positions * 5 moves each)")
    IO.puts("\nTotal: #{total}")

    total
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(&String.contains?(&1, "/dev/grid"))
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [_, x, y, size, used, avail, _] =
      Regex.run(~r/\/dev\/grid\/node-x(\d+)-y(\d+) +(\d+)T +(\d+)T +(\d+)T +(\d+)%/, line)

    {String.to_integer(x), String.to_integer(y), String.to_integer(size), String.to_integer(used),
     String.to_integer(avail)}
  end
end
