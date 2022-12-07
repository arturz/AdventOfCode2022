defmodule AdventOfCode2022.Day07Test do
  use ExUnit.Case

  import AdventOfCode2022.Day07

  test "example for the first part" do
    assert "test/support/day07/example.txt" |> File.read!() |> first_part() === 95437
  end

  test "example for the second part" do
    assert "test/support/day07/example.txt" |> File.read!() |> second_part() === 24_933_642
  end
end
