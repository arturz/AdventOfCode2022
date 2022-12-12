defmodule AdventOfCode2022.Day11 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    monkeys = get_monkeys(input)

    solve(20, monkeys, &div(&1, 3))
  end

  @spec second_part(String.t()) :: no_return()
  def second_part(input) do
    monkeys = get_monkeys(input)

    test_divisors_lcm = monkeys |> Map.values() |> Enum.map(& &1.test_divisor) |> Enum.product()

    solve(10000, monkeys, &rem(&1, test_divisors_lcm))
  end

  @spec solve(integer(), map(), (integer() -> integer())) :: integer()
  def solve(rounds, monkeys, adjust_worry_level_modifier) do
    1..rounds
    |> Enum.reduce(
      monkeys,
      fn _, monkeys ->
        monkeys
        |> Map.keys()
        |> Enum.reduce(monkeys, fn id, monkeys ->
          monkey = monkeys[id]

          Enum.reduce(monkey.items, monkeys, fn item, monkeys ->
            new_item = item |> monkey.worry_level_modifier.() |> adjust_worry_level_modifier.()
            to_monkey = monkey.item_thrower.(new_item)

            monkeys
            |> put_in([to_monkey, :items], get_in(monkeys, [to_monkey, :items]) ++ [new_item])
          end)
          |> put_in([id, :items], [])
          |> put_in([id, :activity], monkey.activity + length(monkey.items))
        end)
      end
    )
    |> Enum.map(&(&1 |> elem(1) |> Map.get(:activity)))
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  @spec get_monkeys(String.t()) :: map()
  defp get_monkeys(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_every(6)
    |> Enum.map(fn
      [
        <<"Monkey ", id::binary-size(1), ":">>,
        <<"Starting items: ", items::binary>>,
        <<"Operation: ", operation::binary>>,
        <<"Test: divisible by ", test_divisor::binary>>,
        <<"If true: throw to monkey ", test_passed_monkey_id::binary>>,
        <<"If false: throw to monkey ", test_failed_monkey_id::binary>>
      ] ->
        {
          id,
          %{
            items: items |> String.split(", ") |> Enum.map(&String.to_integer/1),
            activity: 0,
            worry_level_modifier: build_worry_level_modifier(operation),
            item_thrower:
              build_item_thrower(
                String.to_integer(test_divisor),
                test_passed_monkey_id,
                test_failed_monkey_id
              ),
            test_divisor: String.to_integer(test_divisor)
          }
        }
    end)
    |> Map.new()
  end

  @spec build_worry_level_modifier(String.t()) :: (integer() -> integer())
  defp build_worry_level_modifier(operation) do
    fn worry_level ->
      operation
      |> Code.eval_string(old: worry_level)
      |> elem(0)
    end
  end

  @spec build_item_thrower(integer(), String.t(), String.t()) :: (integer() -> String.t())
  defp build_item_thrower(test_divisor, test_passed_monkey_id, test_failed_monkey_id) do
    fn worry_level ->
      if rem(worry_level, test_divisor) === 0,
        do: test_passed_monkey_id,
        else: test_failed_monkey_id
    end
  end
end
