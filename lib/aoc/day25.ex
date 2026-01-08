defmodule Aoc.Day25 do
  def part1(args) do
    instructions = parse_input(args)

    # Find the lowest positive integer that produces a clock signal
    Stream.iterate(1, &(&1 + 1))
    |> Enum.find(fn a ->
      produces_clock_signal?(instructions, a)
    end)
  end

  def part2(_args) do
    "Merry Christmas!"
  end

  def produces_clock_signal?(instructions, a_value) do
    registers = %{"a" => a_value, "b" => 0, "c" => 0, "d" => 0}

    # Run the program and capture outputs
    # We'll check for at least 100 outputs to be confident it's a repeating pattern
    case execute_with_output(instructions, registers, 0, [], 100) do
      {:ok, outputs} -> valid_clock_signal?(outputs)
      :error -> false
    end
  end

  def valid_clock_signal?(outputs) do
    # Check if outputs alternate between 0 and 1
    outputs
    |> Enum.with_index()
    |> Enum.all?(fn {val, idx} ->
      expected = rem(idx, 2)
      val == expected
    end)
  end

  def execute_with_output(_instructions, _registers, _offset, outputs, max_outputs)
      when length(outputs) >= max_outputs do
    {:ok, Enum.reverse(outputs)}
  end

  def execute_with_output(_instructions, _registers, nil, _outputs, _max_outputs) do
    :error
  end

  def execute_with_output(instructions, _registers, offset, _outputs, _max_outputs)
      when offset < 0 or offset >= length(instructions) do
    :error
  end

  def execute_with_output(instructions, registers, offset, outputs, max_outputs) do
    instruction = Enum.at(instructions, offset)

    case execute_opscode(instruction, registers, offset) do
      {:output, value, new_registers, new_offset} ->
        # Check if this output breaks the pattern
        expected = rem(length(outputs), 2)

        if value == expected do
          execute_with_output(
            instructions,
            new_registers,
            new_offset,
            [value | outputs],
            max_outputs
          )
        else
          :error
        end

      {new_registers, new_offset, toggle_offset} ->
        new_instructions =
          if toggle_offset do
            toggle_instruction_at(instructions, toggle_offset)
          else
            instructions
          end

        execute_with_output(new_instructions, new_registers, new_offset, outputs, max_outputs)
    end
  end

  def execute_opscode(nil, registers, _offset), do: {registers, nil, nil}

  def execute_opscode({:cpy, x, y}, registers, offset) when is_binary(y) do
    value = Map.get(registers, x, x)
    {Map.put(registers, y, value), offset + 1, nil}
  end

  def execute_opscode({:cpy, _x, _y}, registers, offset) do
    {registers, offset + 1, nil}
  end

  def execute_opscode({:inc, x}, registers, offset) when is_binary(x) do
    {Map.update(registers, x, 1, &(&1 + 1)), offset + 1, nil}
  end

  def execute_opscode({:inc, _x}, registers, offset) do
    {registers, offset + 1, nil}
  end

  def execute_opscode({:dec, x}, registers, offset) when is_binary(x) do
    {Map.update(registers, x, -1, &(&1 - 1)), offset + 1, nil}
  end

  def execute_opscode({:dec, _x}, registers, offset) do
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

  def execute_opscode({:out, x}, registers, offset) do
    out_value = Map.get(registers, x, x)
    {:output, out_value, registers, offset + 1}
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

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(<<"cpy ", rest::binary>>) do
    [arg1, arg2] =
      String.split(rest, " ", trim: true)
      |> Enum.map(&parse_arg/1)

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
      |> Enum.map(&parse_arg/1)

    {:jnz, arg1, arg2}
  end

  def parse_line(<<"tgl ", rest::binary>>) do
    {:tgl, String.trim(rest)}
  end

  def parse_line(<<"out ", rest::binary>>) do
    arg = parse_arg(String.trim(rest))
    {:out, arg}
  end

  defp parse_arg(arg) do
    case Integer.parse(arg) do
      {num, _} -> num
      :error -> arg
    end
  end
end
