defmodule AdventOfCode2022.Day19 do
  @moduledoc false

  alias AdventOfCode2022.Day19.{Bag, Blueprint, TradeService}

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    [_, blueprint] = Blueprint.get_blueprints(input)

    bag = %Bag{}

    bag
    |> get_possibilities(blueprint, 1, %{did_nothing: false, previous_bag: bag})
    |> Enum.sort_by(&Map.fetch!(&1, :geode), :desc)
    |> List.first()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    input
  end

  # defp get_possibilities(fringe, _blueprint, day) when day > 16 do
  #   [Heap.root(fringe)]
  # end

  # defp get_possibilities(fringe, blueprint, day) do
  #   bag = Heap.root(fringe)
  #   fringe = Heap.pop(fringe)

  #   [:ore_robot, :clay_robot, :obsidian_robot]
  #   |> Enum.reduce(fringe, fn robot_name, fringe ->
  #     if TradeService.can_afford?(bag, blueprint, robot_name) do
  #       Heap.push(fringe, bag |> TradeService.buy_if_can_afford(blueprint, robot_name) |> Bag.run_robots())
  #     else
  #       fringe
  #     end
  #   end)
  #   |> Enum.map(& get_possibilities(fringe, blueprint, day + 1))
  #   |> Enum.reduce(Heap.push(fringe, Bag.run_robots(bag)), &Enum.concat/2)
  # end

  defp get_possibilities(bag, _blueprint, day, _optimization) when day > 24 do
    [bag]
  end

  defp get_possibilities(bag, blueprint, day, %{
         did_nothing: did_nothing,
         previous_bag: previous_bag
       }) do
    if TradeService.can_afford?(bag, blueprint, :geode_robot) do
      get_possibilities(
        bag
        |> TradeService.buy_if_can_afford(blueprint, :geode_robot)
        |> Bag.run_robots(:geode_robot),
        blueprint,
        day + 1,
        %{did_nothing: false, previous_bag: bag}
      )
    else
      [:ore_robot, :clay_robot, :obsidian_robot]
      |> Enum.map(fn robot_name ->
        if TradeService.can_afford?(bag, blueprint, robot_name) and
             not (did_nothing and TradeService.can_afford?(previous_bag, blueprint, robot_name)) and
             not (day > 19 and bag.geode_robot < 1) do
          get_possibilities(
            bag
            |> TradeService.buy_if_can_afford(blueprint, robot_name)
            |> Bag.run_robots(robot_name),
            blueprint,
            day + 1,
            %{did_nothing: false, previous_bag: bag}
          )
        else
          []
        end
      end)
      |> Enum.reduce(
        get_possibilities(Bag.run_robots(bag), blueprint, day + 1, %{
          did_nothing: true,
          previous_bag: bag
        }),
        &Enum.concat/2
      )
    end
  end
end
