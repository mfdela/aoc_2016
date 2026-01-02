defmodule Aoc.Day15 do
  def part1(args) do
    # use chinese remainder theorem
    args
    |> parse_input()
    |> solve_crt()

    # enumerate all possible combinations of discs
    # args
    # |> parse_input()
    # |> find_button_time()
  end

  def part2(args) do
    discs =
      args
      |> parse_input()

    last_disc = map_size(discs)

    Map.put(discs, last_disc + 1, %{:slots => 11, :start => 0})
    |> solve_crt()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  def parse_line(line) do
    [disc, slots, start_pos] =
      Regex.run(
        ~r/Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)/,
        line,
        capture: :all_but_first
      )

    {String.to_integer(disc),
     %{:slots => String.to_integer(slots), :start => String.to_integer(start_pos)}}
  end

  def find_button_time(discs) do
    # For each disc, find a time that satisfies all previous discs and this one
    # Start with time=0 and step=1 (can press at any time)
    discs
    |> Enum.reduce({0, 1}, fn {disc_num, disc_params}, {time, step} ->
      # Find the next time >= current time that works for this disc
      next_time =
        Stream.iterate(time, &(&1 + step))
        |> Enum.find(fn t ->
          rem(disc_params.start + t + disc_num, disc_params.slots) == 0
        end)

      # New step is LCM of current step and disc's slots
      # This ensures we maintain alignment with all previous discs
      new_step = lcm(step, disc_params.slots)

      {next_time, new_step}
    end)
    |> elem(0)
  end

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(abs(a * b), Integer.gcd(a, b))

  def solve_crt(discs) do
    discs
    |> Enum.map(fn {disc_num, disc_params} ->
      # We need: (initial_pos + T + disc_num) % slots = 0
      # Which means: T ≡ -(initial_pos + disc_num) (mod slots)
      remainder = Integer.mod(-disc_params.start - disc_num, disc_params.slots)
      {remainder, disc_params.slots}
    end)
    |> chinese_remainder_theorem()
  end

  def chinese_remainder_theorem(congruences) do
    [{remainder, modulus} | rest] = congruences

    Enum.reduce(rest, {remainder, modulus}, fn {rem2, mod2}, {rem1, mod1} ->
      merge_congruences(rem1, mod1, rem2, mod2)
    end)
    |> elem(0)
  end

  # Merge two congruences: x ≡ rem1 (mod mod1) and x ≡ rem2 (mod mod2)
  def merge_congruences(rem1, mod1, rem2, mod2) do
    # Extended Euclidean algorithm
    {gcd_val, bezout1, _bezout2} = extended_gcd(mod1, mod2)

    # Check if solution exists
    if Integer.mod(rem2 - rem1, gcd_val) != 0 do
      raise "No solution exists!"
    end

    # Combined modulus (LCM)
    lcm = div(mod1 * mod2, gcd_val)

    # Solution using Bezout coefficients
    # x = rem1 + mod1 * bezout1 * (rem2 - rem1) / gcd
    diff = div(rem2 - rem1, gcd_val)
    solution = rem1 + mod1 * bezout1 * diff

    # Normalize to [0, lcm)
    solution = Integer.mod(solution, lcm)

    {solution, lcm}
  end

  # Extended Euclidean Algorithm
  # Returns {gcd, x, y} where gcd = a*x + b*y
  def extended_gcd(a, 0), do: {a, 1, 0}

  def extended_gcd(a, b) do
    {gcd_val, x1, y1} = extended_gcd(b, Integer.mod(a, b))
    x = y1
    y = x1 - div(a, b) * y1
    {gcd_val, x, y}
  end
end
