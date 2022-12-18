defmodule AdventOfCode2022.Day18 do
  @moduledoc false

  @type coord :: {integer(), integer(), integer()}
  @type boundaries :: {integer(), integer(), integer(), integer(), integer(), integer()}

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    coords = get_coords(input)

    coords
    |> Enum.map(&(&1 |> get_empty_space_around(coords) |> length()))
    |> Enum.sum()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    coords = get_coords(input)

    x = coords |> Enum.map(&elem(&1, 0)) |> Enum.sort()
    y = coords |> Enum.map(&elem(&1, 1)) |> Enum.sort()
    z = coords |> Enum.map(&elem(&1, 2)) |> Enum.sort()

    boundaries =
      {List.first(x) - 1, List.last(x) + 1, List.first(y) - 1, List.last(y) + 1, List.first(z) - 1, List.last(z) + 1}

    flooded = flood_space(coords, [{elem(boundaries, 0), elem(boundaries, 2), elem(boundaries, 4)}], MapSet.new(), boundaries)

    coords
    |> Enum.map(&(&1 |> get_flooded_space_around(flooded) |> length()))
    |> Enum.sum()
  end

  @spec flood_space(MapSet.t(coord()), list(coord()), MapSet.t(coord()), boundaries()) :: MapSet.t(coord())
  def flood_space(_coords, [], flooded, _boundaries) do
    flooded
  end

  def flood_space(coords, fringe, flooded, {minX, maxX, minY, maxY, minZ, maxZ} = boundaries) do
    [space | fringe] = fringe

    flooded = MapSet.put(flooded, space)

    fringe =
      get_empty_space_around(space, coords)
      |> Stream.reject(&(&1 in flooded))
      |> Stream.reject(fn {x, y, z} ->
        x < minX or x > maxX or y < minY or y > maxY or z < minZ or z > maxZ
      end)
      |> Enum.concat(fringe)

    flood_space(coords, fringe, flooded, boundaries)
  end

  @spec get_empty_space_around(coord(), MapSet.t(coord())) :: list(coord())
  defp get_empty_space_around(block, coords) do
    block
    |> get_space_around()
    |> Enum.reject(&(&1 in coords))
  end

  @spec get_flooded_space_around(coord(), MapSet.t(coord())) :: list(coord())
  defp get_flooded_space_around(block, flooded) do
    block
    |> get_space_around()
    |> Enum.filter(&(&1 in flooded))
  end

  @spec get_space_around(coord()) :: list(coord())
  defp get_space_around(block) do
    Enum.flat_map(0..2, fn i ->
      Enum.map([-1, 1], fn addition ->
        put_elem(block, i, elem(block, i) + addition)
      end)
    end)
  end

  @spec get_coords(String.t()) :: MapSet.t(coord())
  defp get_coords(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> MapSet.new()
  end
end
