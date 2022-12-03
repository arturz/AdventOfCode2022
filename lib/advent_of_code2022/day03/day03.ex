defmodule AdventOfCode2022.Day03 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> String.split("\n")
    |> Enum.map(&get_priority_of_item_in_both_rucksack_compartments(&1))
    |> Enum.sum()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    input
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.map(&find_rucksacks_badge(&1))
    |> Enum.map(&get_priority_of_item(&1))
    |> Enum.sum()
  end

  @spec get_priority_of_item_in_both_rucksack_compartments(String.t()) :: integer()
  defp get_priority_of_item_in_both_rucksack_compartments(rucksack) do
    rucksack
    |> String.to_charlist()
    |> Enum.chunk_every(rucksack |> String.length() |> div(2))
    |> Enum.map(&MapSet.new/1)
    |> then(fn [first_compartment, second_compartment] ->
      MapSet.intersection(first_compartment, second_compartment)
    end)
    |> Enum.to_list()
    |> List.first()
    |> get_priority_of_item()
  end

  @spec get_priority_of_item(integer()) :: integer()
  defp get_priority_of_item(item) when item >= 97, do: item - 96
  defp get_priority_of_item(item), do: item - 38

  @spec find_rucksacks_badge(String.t()) :: integer()
  defp find_rucksacks_badge(rucksacks) do
    rucksacks
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.to_list()
    |> List.first()
  end
end
