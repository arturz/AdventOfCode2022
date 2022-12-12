defmodule AdventOfCode2022.Day11Test do
  use ExUnit.Case

  import AdventOfCode2022.Day11

  test "example for the first part" do
    assert "test/support/day11/example.txt" |> File.read!() |> first_part() === 10605
  end

  @tag timeout: :infinity
  test "example for the second part" do
    assert "test/support/day11/example.txt" |> File.read!() |> second_part() === 2_713_310_158
  end
end
