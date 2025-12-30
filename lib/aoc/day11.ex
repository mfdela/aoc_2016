defmodule Aoc.Day11 do
  def part1(args) do
    initial_state = args |> parse_input()

    # Convert to internal state format: {elevator_floor, floors_map}
    state = {1, initial_state}

    bfs([{state, 0}], MapSet.new([normalize_state(state)]))
  end

  def part2(args) do
    initial_state =
      args
      |> parse_input()
      |> Map.update!(1, fn {microchips, generators} ->
        {["elerium", "dilithium"] ++ microchips, ["elerium", "dilithium"] ++ generators}
      end)

    # Convert to internal state format: {elevator_floor, floors_map}
    state = {1, initial_state}

    bfs([{state, 0}], MapSet.new([normalize_state(state)]))
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  def parse_line(line) do
    floor =
      case Regex.run(~r/The (\w+) floor contains /, line, capture: :all_but_first) do
        ["first"] -> 1
        ["second"] -> 2
        ["third"] -> 3
        ["fourth"] -> 4
      end

    microchips =
      Regex.scan(~r/(\w+)-compatible microchip/, line, capture: :all_but_first)
      |> List.flatten()

    generators =
      Regex.scan(~r/(\w+) generator/, line, capture: :all_but_first)
      |> List.flatten()

    {floor, {microchips, generators}}
  end

  # BFS to find minimum steps
  def bfs([], _visited), do: nil

  def bfs([{state, steps} | rest], visited) do
    if goal_state?(state) do
      steps
    else
      new_states =
        generate_moves(state)
        |> Enum.filter(&valid_state?/1)
        |> Enum.reject(fn new_state ->
          MapSet.member?(visited, normalize_state(new_state))
        end)

      new_visited =
        Enum.reduce(new_states, visited, fn new_state, acc ->
          MapSet.put(acc, normalize_state(new_state))
        end)

      new_queue = rest ++ Enum.map(new_states, &{&1, steps + 1})

      bfs(new_queue, new_visited)
    end
  end

  # Check if all items are on floor 4
  def goal_state?({_elevator, floors}) do
    Enum.all?([1, 2, 3], fn floor ->
      {microchips, generators} = Map.get(floors, floor, {[], []})
      microchips == [] and generators == []
    end)
  end

  # Generate all valid moves from current state
  def generate_moves({elevator_floor, floors}) do
    {microchips, generators} = Map.get(floors, elevator_floor, {[], []})

    # All items on current floor
    items =
      Enum.map(microchips, &{:microchip, &1}) ++
        Enum.map(generators, &{:generator, &1})

    # Generate all combinations of 1 or 2 items
    combinations =
      for(item <- items, do: [item]) ++
        for i <- items, j <- items, i < j, do: [i, j]

    # Try moving up and down
    directions =
      [elevator_floor + 1, elevator_floor - 1]
      |> Enum.filter(&(&1 >= 1 and &1 <= 4))

    for dir <- directions, combo <- combinations do
      move_items({elevator_floor, floors}, combo, dir)
    end
  end

  # Move items from current floor to target floor
  def move_items({current_floor, floors}, items, target_floor) do
    # Remove items from current floor
    {curr_m, curr_g} = Map.get(floors, current_floor, {[], []})

    {items_m, items_g} =
      Enum.reduce(items, {[], []}, fn
        {:microchip, name}, {ms, gs} -> {[name | ms], gs}
        {:generator, name}, {ms, gs} -> {ms, [name | gs]}
      end)

    new_curr_m = curr_m -- items_m
    new_curr_g = curr_g -- items_g

    # Add items to target floor
    {target_m, target_g} = Map.get(floors, target_floor, {[], []})
    new_target_m = (target_m ++ items_m) |> Enum.sort()
    new_target_g = (target_g ++ items_g) |> Enum.sort()

    new_floors =
      floors
      |> Map.put(current_floor, {new_curr_m, new_curr_g})
      |> Map.put(target_floor, {new_target_m, new_target_g})

    {target_floor, new_floors}
  end

  # Check if a state is valid (no microchips get fried)
  def valid_state?({_elevator, floors}) do
    Enum.all?(floors, fn {_floor_num, {microchips, generators}} ->
      # A floor is valid if:
      # - No generators present, OR
      # - Every microchip has its matching generator
      generators == [] or
        Enum.all?(microchips, fn m -> m in generators end)
    end)
  end

  # Normalize state for deduplication (items are interchangeable pairs)
  # We only care about the pattern of microchip-generator pairs, not their names
  def normalize_state({elevator, floors}) do
    normalized_floors =
      Enum.map(1..4, fn floor ->
        {microchips, generators} = Map.get(floors, floor, {[], []})

        # Convert to pairs: for each element type, record which floor has M and which has G
        pairs =
          (microchips ++ generators)
          |> Enum.uniq()
          |> Enum.map(fn element ->
            m_floor = if element in microchips, do: floor, else: nil
            g_floor = if element in generators, do: floor, else: nil
            {m_floor, g_floor}
          end)
          |> Enum.reject(&(&1 == {nil, nil}))

        pairs
      end)
      |> List.flatten()
      |> Enum.sort()

    {elevator, normalized_floors}
  end
end
