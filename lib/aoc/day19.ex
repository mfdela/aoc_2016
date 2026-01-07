defmodule Aoc.Day19 do
  def part1(args) do
    # O(n^2)
    # args
    # |> eliminate_elves_left()

    # O(1)
    josephus(args)
  end

  def part2(args) do
    # O(n^2)
    # args
    # |> eliminate_elves_opposite()

    # O(1)
    circle_opposite(args)
  end

  # Fast version for part 1 using Josephus formula
  # J(n) for k=2 (every second person) can be computed directly
  def josephus(n) do
    # Find highest power of 2 <= n
    p = :math.log2(n) |> floor() |> then(&:math.pow(2, &1)) |> round()
    l = n - p
    2 * l + 1
  end

  # Fast version for part 2 using pattern recognition
  # The pattern for "across the circle" follows a specific formula
  def circle_opposite(n) do
    # Find highest power of 3 <= n
    p = (:math.log(n) / :math.log(3)) |> floor() |> then(&:math.pow(3, &1)) |> round()

    cond do
      n == p -> n
      n <= 2 * p -> n - p
      true -> 2 * n - 3 * p
    end
  end

  def eliminate_elves_left(n) do
    queue = Enum.reduce(1..n, :queue.new(), fn i, q -> :queue.in(i, q) end)
    eliminate_left(queue)
  end

  def eliminate_left(queue) do
    case :queue.out(queue) do
      # Only one elf left
      {{:value, last}, {[], []}} ->
        last

      {{:value, elf}, queue2} ->
        # Remove the next elf (steal their presents)
        {{:value, _eliminated}, queue3} = :queue.out(queue2)
        # Put current elf back at the end
        queue4 = :queue.in(elf, queue3)
        eliminate_left(queue4)
    end
  end

  def eliminate_elves_opposite(n) do
    half = div(n, 2)
    left = Enum.reduce(1..half, :queue.new(), fn i, q -> :queue.in(i, q) end)
    right = Enum.reduce((half + 1)..n, :queue.new(), fn i, q -> :queue.in(i, q) end)

    eliminate_opposite(left, right)
  end

  def eliminate_opposite(left, right) do
    total = :queue.len(left) + :queue.len(right)

    cond do
      # Only one elf remains
      total == 1 ->
        if :queue.len(left) == 1 do
          {{:value, winner}, _} = :queue.out(left)
          winner
        else
          {{:value, winner}, _} = :queue.out(right)
          winner
        end

      # Eliminate from left (when left has more elves)
      :queue.len(left) > :queue.len(right) ->
        {{:value, _eliminated}, new_left} = :queue.out(left)

        case :queue.out(right) do
          {:empty, _} ->
            eliminate_opposite(new_left, right)

          {{:value, current}, new_right} ->
            new_left2 = :queue.in(current, new_left)
            eliminate_opposite(new_left2, new_right)
        end

      # Eliminate from right (when balanced or right has more)
      true ->
        {{:value, _eliminated}, new_right} = :queue.out(right)

        case :queue.out(left) do
          {:empty, _} ->
            eliminate_opposite(left, new_right)

          {{:value, current}, new_left} ->
            new_right2 = :queue.in(current, new_right)
            eliminate_opposite(new_left, new_right2)
        end
    end
  end
end
