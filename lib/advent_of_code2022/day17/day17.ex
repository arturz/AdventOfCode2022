defmodule AdventOfCode2022.Day17 do
  @moduledoc false

  @rocks [
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
    [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}],
    [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}],
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}],
    [{0, 0}, {1, 0}, {0, 1}, {1, 1}]
  ]

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    pattern = String.split(input, "", trim: true)
    first_part_spawn_rock(MapSet.new(), 0, pattern, pattern)
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    pattern = String.split(input, "", trim: true)
    second_part_spawn_rock(MapSet.new(), 0, [], pattern, pattern)
  end

  def first_part_spawn_rock(taken, rocks_count, _, _) when rocks_count > 2022 do
    taken |> Enum.map(&elem(&1, 1)) |> Enum.sort(:desc) |> List.first() |> Kernel.-(1)
  end

  def first_part_spawn_rock(taken, rocks_count, pattern, full_pattern) do
    highest_y = taken |> Enum.map(&elem(&1, 1)) |> Enum.sort(:desc) |> List.first() || 0

    {fallen_rock, pattern} =
      Enum.at(@rocks, rem(rocks_count, 5))
      |> Enum.map(fn {x, y} -> {x + 2, y + highest_y + if(rocks_count === 0, do: 3, else: 4)} end)
      |> fall_rock(taken, pattern, full_pattern)

    first_part_spawn_rock(
      MapSet.union(taken, MapSet.new(fallen_rock)),
      rocks_count + 1,
      pattern,
      full_pattern
    )
  end

  def second_part_spawn_rock(taken, rocks_count, history, pattern, full_pattern) do
    highest_y = taken |> Enum.map(&elem(&1, 1)) |> Enum.sort(:desc) |> List.first() || 0

    {fallen_rock, pattern} =
      Enum.at(@rocks, rem(rocks_count, 5))
      |> Enum.map(fn {x, y} -> {x + 2, y + highest_y + if(rocks_count === 0, do: 3, else: 4)} end)
      |> fall_rock(taken, pattern, full_pattern)

    second_part_spawn_rock(
      MapSet.union(taken, MapSet.new(fallen_rock)),
      rocks_count + 1,
      history,
      pattern,
      full_pattern
    )
  end

  def fall_rock(rock, taken, [], full_pattern),
    do: fall_rock(rock, taken, full_pattern, full_pattern)

  def fall_rock(rock, taken, [jet | next_pattern], full_pattern) do
    moved_rock_by_jet = move_rock_by_jet(rock, taken, jet)

    if can_rock_be_moved_down?(moved_rock_by_jet, taken) do
      moved_rock_by_jet
      |> move_rock_down(taken)
      |> fall_rock(taken, next_pattern, full_pattern)
    else
      {moved_rock_by_jet, next_pattern}
    end
  end

  defp move_rock_by_jet(rock, taken, jet) do
    moved_rock_by_jet =
      case jet do
        "<" -> Enum.map(rock, fn {x, y} -> {x - 1, y} end)
        ">" -> Enum.map(rock, fn {x, y} -> {x + 1, y} end)
      end

    if Enum.all?(moved_rock_by_jet, fn {x, y} -> {x, y} not in taken and x < 7 and x >= 0 end),
      do: moved_rock_by_jet,
      else: rock
  end

  defp move_rock_down(rock, taken) do
    if can_rock_be_moved_down?(rock, taken),
      do: Enum.map(rock, fn {x, y} -> {x, y - 1} end),
      else: rock
  end

  defp can_rock_be_moved_down?(rock, taken),
    do: Enum.all?(rock, fn {x, y} -> {x, y - 1} not in taken and y > 0 end)

  def visualize(taken) do
    groupped_rocks = Enum.group_by(taken, &elem(&1, 1))

    highest = groupped_rocks |> Enum.sort_by(&elem(&1, 0), :desc) |> List.first() |> elem(0)

    highest..0
    |> Enum.map(fn y ->
      if groupped_rocks[y] do
        row = groupped_rocks[y] |> Enum.map(&elem(&1, 0))

        IO.write("|")

        Enum.each(0..6, fn x ->
          if x in row, do: IO.write("#"), else: IO.write(".")
        end)

        IO.write("|\n")
      else
        IO.puts("|.......|")
      end
    end)
    |> then(fn _ -> IO.write("+-------+\n\n") end)
  end
end
