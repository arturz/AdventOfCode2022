defmodule AdventOfCode2022.Day06 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> String.split("", trim: true)
    |> get_marker_position(0, 4)
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    input
    |> String.split("", trim: true)
    |> get_marker_position(0, 14)
  end

  @spec get_marker_position(list(), integer(), integer()) :: integer()
  defp get_marker_position([_head | tail] = list, offset, marker_length) do
    if list |> Enum.take(marker_length) |> MapSet.new() |> MapSet.size() === marker_length do
      offset + marker_length
    else
      get_marker_position(tail, offset + 1, marker_length)
    end
  end
end
