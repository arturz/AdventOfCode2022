defmodule AdventOfCode2022.Day05 do
  @moduledoc false

  alias Utils.Stack

  @spec first_part(String.t()) :: String.t()
  def first_part(input) do
    [crates_drawing, moves] = String.split(input, "\n\n")
    crates = parse_crates_drawing(crates_drawing)

    moves
    |> String.split("\n")
    |> Enum.map(
      &Regex.named_captures(~r/^move (?<amount>\d+) from (?<from>\d+) to (?<to>\d+)$/, &1)
    )
    |> Enum.reduce(crates, fn %{"amount" => amount, "from" => from, "to" => to}, crates ->
      {items, crates_from_stack} = Stack.pop(crates[from], String.to_integer(amount))
      crates_to_stack = Stack.push_list(crates[to], items)

      crates
      |> Map.put(from, crates_from_stack)
      |> Map.put(to, crates_to_stack)
    end)
    |> Map.values()
    |> Enum.map(&Stack.top/1)
    |> Enum.join("")
  end

  @spec second_part(String.t()) :: String.t()
  def second_part(input) do
    [crates_drawing, moves] = String.split(input, "\n\n")
    crates = parse_crates_drawing(crates_drawing)

    moves
    |> String.split("\n")
    |> Enum.map(
      &Regex.named_captures(~r/^move (?<amount>\d+) from (?<from>\d+) to (?<to>\d+)$/, &1)
    )
    |> Enum.reduce(crates, fn %{"amount" => amount, "from" => from, "to" => to}, crates ->
      {items, crates_from_stack} = Stack.pop(crates[from], String.to_integer(amount))
      crates_to_stack = Stack.push_list(crates[to], Enum.reverse(items))

      crates
      |> Map.put(from, crates_from_stack)
      |> Map.put(to, crates_to_stack)
    end)
    |> Map.values()
    |> Enum.map(&Stack.top/1)
    |> Enum.join("")
  end

  @spec parse_crates_drawing(String.t()) :: %{required(String.t()) => Stack.t()}
  defp parse_crates_drawing(crates_drawing) do
    crates_drawing
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
    |> transpose()
    |> Enum.map(&Enum.reverse/1)
    |> Enum.filter(fn
      [" " | _] -> false
      _ -> true
    end)
    |> Enum.map(fn line ->
      Enum.filter(line, &(&1 != " "))
    end)
    |> Enum.map(fn [id | stack_items] ->
      {id, Stack.push_list(Stack.new(), stack_items)}
    end)
    |> Map.new()
  end

  @spec transpose(list(list())) :: list(list())
  defp transpose(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
