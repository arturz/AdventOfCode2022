defmodule AdventOfCode2022.Day21 do
  @moduledoc false

  @type monkeys :: %{
          vars: %{
            required(String.t()) => integer()
          },
          maths: %{
            required(String.t()) => {list(integer()), String.t()}
          }
        }

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> get_monkeys()
    |> then(fn ops ->
      Enum.reduce_while(Stream.cycle([nil]), ops, fn
        _, %{vars: _vars, maths: maths} = acc when maths === %{} ->
          {:halt, acc}

        _, %{vars: vars, maths: maths} ->
          {:cont, get_next_iteration(%{vars: vars, maths: maths})}
      end)
    end)
    |> get_in([:vars, "root"])
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    input
    |> get_monkeys()
    |> binary_search(0, 700_000_000_000_000_000_000_000, 1)
  end

  @spec binary_search(monkeys(), integer(), integer(), 1 | -1) :: integer()
  defp binary_search(monkeys, low, high, 1) when low > high,
    do: binary_search(monkeys, 0, 700_000_000_000_000_000_000_000, -1)

  defp binary_search(monkeys, low, high, order_modifier) do
    mid = div(low + high, 2)
    tmp = calc(monkeys, mid)

    cond do
      tmp === 0 -> mid
      tmp === -order_modifier -> binary_search(monkeys, low, mid - 1, order_modifier)
      tmp === order_modifier -> binary_search(monkeys, mid + 1, high, order_modifier)
    end
  end

  @spec calc(monkeys(), integer()) :: 0 | 1 | -1
  defp calc(monkeys, humn) do
    monkeys
    |> put_in([:vars, "humn"], humn)
    |> then(fn ops ->
      Enum.reduce_while(Stream.cycle([nil]), ops, fn
        _, %{vars: _vars, maths: %{"root" => {[a, b], _operator}} = maths}
        when is_integer(a) and is_integer(b) and map_size(maths) === 1 ->
          cond do
            a - b === 0 -> {:halt, 0}
            # a - b < 0 -> {:halt, 1}
            a < b -> {:halt, 1}
            true -> {:halt, -1}
          end

        _, %{vars: vars, maths: maths} ->
          {:cont, get_next_iteration(%{vars: vars, maths: maths})}
      end)
    end)
  end

  @spec get_monkeys(String.t()) :: monkeys()
  defp get_monkeys(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn
      <<name::binary-size(4), ": ", a::binary-size(4), " ", operator::binary-size(1), " ",
        b::binary-size(4)>> ->
        {name, {[a, b], operator}}

      <<name::binary-size(4), ": ", value::binary>> ->
        {name, String.to_integer(value)}
    end)
    |> Enum.group_by(fn
      {_name, number} when is_integer(number) -> :vars
      _ -> :maths
    end)
    |> Enum.to_list()
    |> Enum.map(&{elem(&1, 0), elem(&1, 1) |> Map.new()})
    |> Map.new()
  end

  @spec get_next_iteration(monkeys()) :: monkeys()
  defp get_next_iteration(%{vars: vars, maths: maths}) do
    maths
    |> Enum.to_list()
    |> Enum.map(fn
      {monkey, {[a, b] = names, operator}} ->
        names =
          names
          |> Enum.map(fn
            name when is_map_key(vars, name) -> vars[name]
            name -> name
          end)

        term =
          if is_integer(a) and is_integer(b) do
            case operator do
              "+" -> a + b
              "-" -> a - b
              "/" -> div(a, b)
              "*" -> a * b
            end
          else
            {names, operator}
          end

        {monkey, term}
    end)
    |> Enum.reduce(%{maths: [], vars: Enum.to_list(vars)}, fn
      {monkey, term}, %{vars: vars} = acc when is_number(term) ->
        Map.put(acc, :vars, vars ++ [{monkey, term}])

      {monkey, term}, %{maths: maths} = acc ->
        Map.put(acc, :maths, maths ++ [{monkey, term}])
    end)
    |> Enum.to_list()
    |> Enum.map(&{elem(&1, 0), elem(&1, 1) |> Map.new()})
    |> Map.new()
  end
end
