defmodule AdventOfCode2022.Day04 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.flat_map(&String.split(&1, "-"))
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.map(&does_pair_overlap(&1))
    |> Enum.filter(&Function.identity/1)
    |> length()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.flat_map(&String.split(&1, "-"))
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.map(&does_pair_overlap_partially(&1))
    |> Enum.filter(&Function.identity/1)
    |> length()
  end

  @spec does_pair_overlap({integer(), integer(), integer(), integer()}) :: boolean()
  defp does_pair_overlap({a_start, a_end, b_start, b_end})
       when (a_start <= b_start and a_end >= b_end) or (a_start >= b_start and a_end <= b_end),
       do: true

  defp does_pair_overlap(_), do: false

  @spec does_pair_overlap_partially({integer(), integer(), integer(), integer()}) :: boolean()
  defp does_pair_overlap_partially({a_start, a_end, b_start, b_end}) do
    not Range.disjoint?(Range.new(a_start, a_end), Range.new(b_start, b_end))
  end
end
