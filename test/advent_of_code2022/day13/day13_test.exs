defmodule AdventOfCode2022.Day13Test do
  use ExUnit.Case

  import AdventOfCode2022.Day13

  test "example for the first part" do
    assert "test/support/day13/example.txt" |> File.read!() |> first_part() === 13
  end

  test "example for the second part" do
    assert "test/support/day13/example.txt" |> File.read!() |> second_part() === 140
  end
end
