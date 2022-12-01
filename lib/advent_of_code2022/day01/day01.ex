defmodule AdventOfCode2022.Day01 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(calories) do
    calories
    |> get_sums_of_calories()
    |> (&max/1).()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(calories) do
    [a, b, c | _] =
      calories
      |> get_sums_of_calories()
      |> Enum.sort(:desc)

    a + b + c
  end

  @spec get_sums_of_calories(String.t()) :: list()
  defp get_sums_of_calories(calories) do
    calories
    |> String.trim()
    |> String.split("\n\n")
    |> Stream.map(&String.split(&1, "\n"))
    |> Stream.map(&map_strings_to_integers/1)
    |> Stream.map(&Enum.sum/1)
    |> Enum.to_list()
  end

  @spec max(Enumerable.t()) :: integer()
  defp max(list) do
    Enum.reduce(list, &max/2)
  end

  @spec map_strings_to_integers(list()) :: list()
  defp map_strings_to_integers(list) do
    Enum.map(list, &String.to_integer/1)
  end
end
