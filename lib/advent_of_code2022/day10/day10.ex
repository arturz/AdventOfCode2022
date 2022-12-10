defmodule AdventOfCode2022.Day10 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> get_cycles()
    |> then(fn cycles ->
      20..220//40
      |> Enum.map(fn number ->
        number * Enum.at(cycles, number - 1)
      end)
      |> Enum.sum()
    end)
  end

  @spec second_part(String.t()) :: no_return()
  def second_part(input) do
    input
    |> get_cycles()
    |> Enum.map_reduce(1, fn
      x, i when i in x..(x + 2) and rem(i, 40) === 0 ->
        {"#\n", 1}

      x, i when i in x..(x + 2) ->
        {"#", i + 1}

      _x, i when rem(i, 40) === 0 ->
        {".\n", 1}

      _x, i ->
        {".", i + 1}
    end)
    |> elem(0)
    |> Enum.join("")
  end

  @spec get_cycles(String.t()) :: list(integer())
  def get_cycles(input) do
    input
    |> String.split("\n")
    |> Enum.flat_map_reduce({1, 0}, fn
      "noop", {x, change} ->
        {[x + change], {x + change, 0}}

      <<"addx ", integer::binary>>, {x, change} ->
        {[x + change, x + change], {x + change, String.to_integer(integer)}}
    end)
    |> elem(0)
  end
end
