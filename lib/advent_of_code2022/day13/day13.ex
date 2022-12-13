defmodule AdventOfCode2022.Day13 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.map(fn {[left, right], index} -> {in_order?(left, right), index} end)
    |> Enum.filter(&elem(&1, 0))
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.sum()
  end

  @first_divider_packet [[2]]
  @second_divider_packet [[6]]

  @spec second_part(String.t()) :: no_return()
  def second_part(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))
    |> Enum.concat([@first_divider_packet, @second_divider_packet])
    |> Enum.sort(&in_order?(&1, &2))
    |> Enum.with_index()
    |> Enum.filter(&(elem(&1, 0) in [@first_divider_packet, @second_divider_packet]))
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.product()
  end

  @spec in_order?(list() | integer(), list() | integer()) :: boolean() | nil
  def in_order?(nil, _right), do: true
  def in_order?(_left, nil), do: false

  def in_order?(left, right) when is_integer(left) and is_integer(right) and left < right,
    do: true

  def in_order?(left, right) when is_integer(left) and is_integer(right) and left > right,
    do: false

  def in_order?(left, right) when is_integer(left) and is_integer(right) and left === right,
    do: nil

  def in_order?(left, right) when is_integer(left) and is_list(right),
    do: in_order?([left], right)

  def in_order?(left, right) when is_list(left) and is_integer(right),
    do: in_order?(left, [right])

  def in_order?(left, right) when is_list(left) and is_list(right) do
    left = pad_trailing(left, length(right))
    right = pad_trailing(right, length(left))

    Enum.zip([left, right])
    |> Enum.reduce_while(nil, fn {a, b}, _result ->
      case in_order?(a, b) do
        true -> {:halt, true}
        false -> {:halt, false}
        nil -> {:cont, nil}
      end
    end)
  end

  @spec pad_trailing(list(), integer()) :: list()
  def pad_trailing(list, desired_length) when length(list) < desired_length do
    pad_trailing(list ++ Enum.map(1..desired_length, fn _ -> nil end), desired_length)
  end

  def pad_trailing(list, _), do: list
end
