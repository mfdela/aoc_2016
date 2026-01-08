defmodule Aoc.Day23 do
  def part1(args) do
    instructions = parse_input(args)
    registers = %{"a" => 7, "b" => 0, "c" => 0, "d" => 0}

    result = execute_instructions(instructions, registers)
    Map.get(result, "a")
  end

  def part2(args) do
    instructions = parse_input(args)
    registers = %{"a" => 12, "b" => 0, "c" => 0, "d" => 0}

    result = execute_instructions(instructions, registers)
    Map.get(result, "a")
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

  def parse_line(<<"tgl ", rest::binary>>) do
    {:tgl, String.trim(rest)}
  end

  def execute_instructions(instructions, registers, offset \\ 0)

  def execute_instructions(_instructions, registers, nil), do: registers

  def execute_instructions(instructions, registers, offset)
      when offset < 0 or offset >= length(instructions) do
    registers
  end

  def execute_instructions(instructions, registers, offset) do
    instruction = Enum.at(instructions, offset)
    {new_registers, new_offset, toggle_offset} = execute_opscode(instruction, registers, offset)

    new_instructions =
      if toggle_offset do
        toggle_instruction_at(instructions, toggle_offset)
      else
        instructions
      end

    execute_instructions(new_instructions, new_registers, new_offset)
  end

  def execute_opscode(nil, registers, _offset), do: {registers, nil, nil}

  def execute_opscode({:cpy, x, y}, registers, offset) when is_binary(y) do
    # Valid cpy: copy value to register
    value = Map.get(registers, x, x)
    {Map.put(registers, y, value), offset + 1, nil}
  end

  def execute_opscode({:cpy, _x, _y}, registers, offset) do
    # Invalid cpy (trying to copy to a number), skip it
    {registers, offset + 1, nil}
  end

  def execute_opscode({:inc, x}, registers, offset) when is_binary(x) do
    {Map.update(registers, x, 1, &(&1 + 1)), offset + 1, nil}
  end

  def execute_opscode({:inc, _x}, registers, offset) do
    # Invalid inc (trying to increment a number), skip it
    {registers, offset + 1, nil}
  end

  def execute_opscode({:dec, x}, registers, offset) when is_binary(x) do
    {Map.update(registers, x, -1, &(&1 - 1)), offset + 1, nil}
  end

  def execute_opscode({:dec, _x}, registers, offset) do
    # Invalid dec (trying to decrement a number), skip it
    {registers, offset + 1, nil}
  end

  def execute_opscode({:jnz, x, y}, registers, offset) do
    test_value = Map.get(registers, x, x)
    jump_offset = Map.get(registers, y, y)

    if test_value != 0 do
      {registers, offset + jump_offset, nil}
    else
      {registers, offset + 1, nil}
    end
  end

  def execute_opscode({:tgl, x}, registers, offset) do
    toggle_offset_value = Map.get(registers, x, x)
    target_offset = offset + toggle_offset_value
    {registers, offset + 1, target_offset}
  end

  def toggle_instruction_at(instructions, target_offset) do
    if target_offset >= 0 and target_offset < length(instructions) do
      List.update_at(instructions, target_offset, &toggle_instruction/1)
    else
      instructions
    end
  end

  def toggle_instruction({:inc, x}), do: {:dec, x}
  def toggle_instruction({:dec, x}), do: {:inc, x}
  def toggle_instruction({:tgl, x}), do: {:inc, x}
  def toggle_instruction({:jnz, x, y}), do: {:cpy, x, y}
  def toggle_instruction({:cpy, x, y}), do: {:jnz, x, y}
end
