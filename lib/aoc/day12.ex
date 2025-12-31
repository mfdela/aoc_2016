defmodule Aoc.Day12 do
  def part1(args) do
    args
    |> parse_input()
    |> execute_instructions(%{"a" => 0, "b" => 0, "c" => 0, "d" => 0}, 0)
    |> Map.get("a")
  end

  def part2(args) do
    args
    |> parse_input()
    |> execute_instructions(%{"a" => 0, "b" => 0, "c" => 1, "d" => 0}, 0)
    |> Map.get("a")
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(<<"cpy ", rest::binary>>) do
    [arg1, arg2] =
      String.split(rest, " ", trim: true)
      |> Enum.map(fn arg ->
        case Integer.parse(arg) do
          {num, _} -> num
          :error -> arg
        end
      end)

    {:cpy, arg1, arg2}
  end

  def parse_line(<<"inc ", rest::binary>>) do
    {:inc, String.trim(rest)}
  end

  def parse_line(<<"dec ", rest::binary>>) do
    {:dec, String.trim(rest)}
  end

  def parse_line(<<"jnz ", rest::binary>>) do
    [arg1, arg2] =
      String.split(rest, " ", trim: true)
      |> Enum.map(fn arg ->
        case Integer.parse(arg) do
          {num, _} -> num
          :error -> arg
        end
      end)

    {:jnz, arg1, arg2}
  end

  def execute_instructions(_instructions, registers, nil), do: registers

  def execute_instructions(instructions, registers, offset) do
    {new_registers, new_offset} =
      execute_opscode(Enum.at(instructions, offset), registers, offset)

    execute_instructions(instructions, new_registers, new_offset)
  end

  def execute_opscode(nil, registers, offset), do: {registers, nil}

  def execute_opscode({:cpy, x, y}, registers, offset) do
    cpy = Map.get(registers, x, x)
    {Map.put(registers, y, cpy), offset + 1}
  end

  def execute_opscode({opscode, x}, registers, offset) do
    case opscode do
      :inc -> {Map.update!(registers, x, &(&1 + 1)), offset + 1}
      :dec -> {Map.update!(registers, x, &(&1 - 1)), offset + 1}
    end
  end

  def execute_opscode({:jnz, x, y}, registers, offset) do
    if Map.get(registers, x, x) != 0 do
      {registers, offset + y}
    else
      {registers, offset + 1}
    end
  end
end
