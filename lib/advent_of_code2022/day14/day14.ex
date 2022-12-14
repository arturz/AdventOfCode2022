defmodule AdventOfCode2022.Day14 do
  @moduledoc false

  @type point :: {integer(), integer()}

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    points = get_points(input)
    highest_y = get_highest_y(points)

    fall_sand(
      points,
      fn {_x, y} -> y < highest_y end,
      fn {_x, y} -> y >= highest_y end,
      0
    )
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    points = get_points(input)
    floor = get_highest_y(points) + 2

    fall_sand(
      points,
      fn {_x, y} -> y + 1 !== floor end,
      fn {x, y} -> x === 500 and y === 0 end,
      1
    )
  end

  @spec get_highest_y(MapSet.t(point())) :: integer()
  defp get_highest_y(points) do
    points
    |> MapSet.to_list()
    |> Enum.map(&elem(&1, 1))
    |> Enum.sort(:desc)
    |> List.first()
  end

  @spec get_points(String.t()) :: MapSet.t(point())
  defp get_points(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" -> ")
      |> Enum.map(fn coords ->
        coords |> String.split(",") |> Enum.map(&String.to_integer(&1)) |> List.to_tuple()
      end)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.flat_map(fn [a, b] -> get_points_on_line(a, b) end)
      |> MapSet.new()
    end)
    |> Enum.reduce(&MapSet.union/2)
  end

  @spec get_points_on_line(point(), point()) :: MapSet.t(point())
  defp get_points_on_line({x1, y1}, {x2, y2}) when x1 === x2,
    do: y1..y2 |> Enum.map(&{x1, &1}) |> MapSet.new()

  defp get_points_on_line({x1, y1}, {x2, y2}) when y1 === y2,
    do: x1..x2 |> Enum.map(&{&1, y1}) |> MapSet.new()

  @spec fall_sand(MapSet.t(point()), (point() -> boolean()), (point() -> boolean()), integer()) ::
          integer()
  defp fall_sand(points, drop_condition, stop_condition, nth_sand) do
    case get_falling_sand_next_position(points, drop_condition, stop_condition, {500, 0}) do
      nil ->
        nth_sand

      next_sand_position ->
        fall_sand(
          MapSet.put(points, next_sand_position),
          drop_condition,
          stop_condition,
          nth_sand + 1
        )
    end
  end

  @spec get_falling_sand_next_position(
          MapSet.t(point()),
          (point() -> boolean()),
          (point() -> boolean()),
          point()
        ) :: point() | nil
  defp get_falling_sand_next_position(points, drop_condition, stop_condition, {x, y} = coords) do
    cond do
      not MapSet.member?(points, {x, y + 1}) and drop_condition.(coords) ->
        get_falling_sand_next_position(points, drop_condition, stop_condition, {x, y + 1})

      not MapSet.member?(points, {x - 1, y + 1}) and drop_condition.(coords) ->
        get_falling_sand_next_position(points, drop_condition, stop_condition, {x - 1, y})

      not MapSet.member?(points, {x + 1, y + 1}) and drop_condition.(coords) ->
        get_falling_sand_next_position(points, drop_condition, stop_condition, {x + 1, y})

      stop_condition.(coords) ->
        nil

      true ->
        {x, y}
    end
  end
end
