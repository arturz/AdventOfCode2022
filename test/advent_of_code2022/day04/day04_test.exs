defmodule AdventOfCode2022.Day04Test do
  use ExUnit.Case

  import AdventOfCode2022.Day04

  test "example" do
    assert "test/support/day04/example.txt" |> File.read!() |> first_part() === 2
  end

  test "example2" do
    assert "test/support/day04/example.txt" |> File.read!() |> second_part() === 4
  end
end
