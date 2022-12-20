defmodule AdventOfCode2022.Day19.Blueprint do
  @moduledoc false

  use Accessible

  defstruct ore_robot: %{},
            clay_robot: %{},
            obsidian_robot: %{},
            geode_robot: %{}

  def get_blueprints(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      ~r/Blueprint \d+: Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
      |> then(fn [
                   ore_robot_ore,
                   clay_robot_ore,
                   obsidian_robot_ore,
                   obsidian_robot_clay,
                   geode_robot_ore,
                   geode_robot_obsidian
                 ] ->
        %__MODULE__{
          ore_robot: build_robot_price(%{ore: ore_robot_ore}),
          clay_robot: build_robot_price(%{ore: clay_robot_ore}),
          obsidian_robot:
            build_robot_price(%{ore: obsidian_robot_ore, clay: obsidian_robot_clay}),
          geode_robot: build_robot_price(%{ore: geode_robot_ore, obsidian: geode_robot_obsidian})
        }
      end)
    end)
  end

  defp build_robot_price(price) do
    %{
      ore: 0,
      clay: 0,
      obsidian: 0
    }
    |> Map.merge(price)
  end
end
