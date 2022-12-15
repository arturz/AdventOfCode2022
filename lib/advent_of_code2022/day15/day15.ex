defmodule AdventOfCode2022.Day15 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input, y \\ 2_000_000) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      ~r/^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$/
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    # |> Enum.at(6)
    # |> List.wrap()
    |> IO.inspect
    |> Enum.map(& get_scans_at_height(&1, y))
    |> Enum.reduce(&MapSet.union/2)
    |> IO.inspect
    |> MapSet.size()
  end

  defp get_scans_at_height({sx, sy, bx, by}, y) do
    s_radius = get_manhattan_distance({sx, sy, bx, by})

    if sy + s_radius > y do
      (sx - (s_radius - (y - sy)))..(sx + (s_radius - (y - sy))) |> Enum.map(fn x -> {x, y} end)
    else
      []
    end
    |> MapSet.new()
  end

  defp get_manhattan_distance({sx, sy, bx, by}) do
    abs(sx - bx) + abs(sy - by)
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    input
  end
end
