defmodule AdventOfCode2022.Day12 do
  @moduledoc false

  defmodule Node do
    defstruct [:pos, :previous]
  end

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    %{map: map, goals: goals, pos: pos} = parse(input)

    height = map |> Enum.filter(& &1 |> elem(0) |> Kernel.==(pos)) |> List.first() |> elem(1)

    {pos, height, 0}
    |> List.wrap()
    |> Qex.new()
    |> bfs(MapSet.new(), map, goals)
  end

  defp bfs(fringe, explored_positions, map, goals) do
    {node, fringe} = Qex.pop!(fringe)

    explored_positions = MapSet.put(explored_positions, elem(node, 0))

    if elem(node, 0) in goals do
      elem(node, 2)
    else
      map
      |> successors(node)
      |> Enum.reject(& elem(&1, 0) in explored_positions)
      |> IO.inspect()
      |> Enum.reduce(fringe, & Qex.push(&2, &1))
      |> bfs(explored_positions, map, goals)
    end
  end

  defp successors(map, {{x, y}, height, steps}) do
    map
    |> Stream.filter(fn {_, tile_height} -> tile_height + 1 >= height end)
    |> Stream.filter(fn
      {{^x, tile_y}, _} when abs(tile_y - y) === 1 -> true
      {{tile_x, ^y}, _} when abs(tile_x - x) === 1 -> true
      _ -> false
    end)
    |> Enum.map(& Tuple.append(&1, steps + 1))
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn
        {height, x} -> {{x, y}, height}
      end)
    end)
    |> Enum.map_reduce(%{goals: MapSet.new(), pos: nil}, fn
      {coords, ?S}, acc -> {{coords, ?a}, Map.put(acc, :goals, MapSet.new([coords]))}
      {coords, ?E}, acc -> {{coords, ?z}, Map.put(acc, :pos, coords)}
      tile, acc -> {tile, acc}
    end)
    |> then(fn {tiles, misc} -> Map.put(misc, :map, Map.new(tiles)) end)
  end

  @spec second_part(String.t()) :: no_return()
  def second_part(input) do
    input
  end
end
