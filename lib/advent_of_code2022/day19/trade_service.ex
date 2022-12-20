defmodule AdventOfCode2022.Day19.TradeService do
  @moduledoc false

  alias AdventOfCode2022.Day19.{Bag, Blueprint}

  def can_afford?(%Bag{} = bag, %Blueprint{} = blueprint, robot_name) do
    blueprint[robot_name]
    |> Enum.all?(fn {item, quantity} ->
      bag[item] >= quantity
    end)
  end

  def buy_if_can_afford(%Bag{} = bag, %Blueprint{} = blueprint, robot_name) do
    if can_afford?(bag, blueprint, robot_name) do
      blueprint[robot_name]
      |> Enum.reduce(bag, fn {item, quantity}, bag ->
        Map.update!(bag, item, &(&1 - quantity))
      end)
      |> Map.update!(robot_name, &(&1 + 1))
    else
      bag
    end
  end
end
