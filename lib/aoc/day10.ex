defmodule Aoc.Day10 do
  def part1(args) do
    args
    |> parse_input()
    |> execute_instructions()
    |> Enum.find(fn {key, values} ->
      String.starts_with?(key, "bot_") and values == ["17", "61"]
    end)
    |> case do
      {"bot_" <> id, _} -> id
      nil -> nil
    end
  end

  def part2(args) do
    state =
      args
      |> parse_input()
      |> execute_instructions()

    ["output_0", "output_1", "output_2"]
    |> Enum.map(&(state[&1] |> hd() |> String.to_integer()))
    |> Enum.product()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(<<"value ", rest::binary>>) do
    Regex.named_captures(~r/(?<value>\d+) goes to (?<target>\w+) (?<id>\d+)/, rest)
    |> Map.put(:type, :value)
  end

  def parse_line(<<"bot ", rest::binary>>) do
    Regex.named_captures(
      ~r/(?<id>\d+) gives low to (?<low_target>\w+) (?<low_id>\d+) and high to (?<high_target>\w+) (?<high_id>\d+)/,
      rest
    )
    |> Map.put(:type, :bot)
  end

  def execute_instructions(instructions) do
    execute_instructions(instructions, %{}, instructions)
  end

  def execute_instructions([], state, []), do: state

  def execute_instructions(_instruction, _state, []), do: :error

  def execute_instructions([], state, remaining_instructions) do
    execute_instructions(remaining_instructions, state, remaining_instructions)
  end

  def execute_instructions([instruction | rest], state, remaining_instructions) do
    {new_state, new_instructions} =
      execute_instruction(instruction, {state, remaining_instructions})

    execute_instructions(rest, new_state, new_instructions)
  end

  def execute_instruction(instruction, {state, instructions}) do
    case instruction do
      %{:type => :value, "id" => id, "target" => target, "value" => value} ->
        {Map.update(state, "#{target}_#{id}", [value], fn values ->
           [value | values] |> Enum.sort_by(&String.to_integer/1)
         end), instructions -- [instruction]}

      %{
        :type => :bot,
        "id" => id,
        "low_target" => low_target,
        "low_id" => low_id,
        "high_target" => high_target,
        "high_id" => high_id
      } ->
        case Map.get(state, "bot_#{id}") do
          [low_value, high_value] ->
            {Map.update(state, "#{low_target}_#{low_id}", [low_value], fn values ->
               [low_value | values] |> Enum.sort_by(&String.to_integer/1)
             end)
             |> Map.update("#{high_target}_#{high_id}", [high_value], fn values ->
               [high_value | values] |> Enum.sort_by(&String.to_integer/1)
             end), instructions -- [instruction]}

          _ ->
            {state, instructions}
        end
    end
  end
end
