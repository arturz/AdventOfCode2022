defmodule AdventOfCode2022.Day19.Bag do
  @moduledoc false

  use Accessible

  defstruct ore: 0,
            clay: 0,
            obsidian: 0,
            geode: 0,
            ore_robot: 1,
            clay_robot: 0,
            obsidian_robot: 0,
            geode_robot: 0

  def run_robots(bag, except \\ nil) do
    [ore_robot: :ore, clay_robot: :clay, obsidian_robot: :obsidian, geode_robot: :geode]
    |> Enum.reduce(bag, fn {robot_name, item}, bag ->
      if bag[robot_name] > 0 and robot_name != except do
        Map.update!(bag, item, &(&1 + bag[robot_name]))
      else
        bag
      end
    end)
  end
end
