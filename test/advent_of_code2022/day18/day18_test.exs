defmodule AdventOfCode2022.Day18Test do
  use ExUnit.Case

  import AdventOfCode2022.Day18

  test "example for the first part" do
    assert "test/support/day18/example.txt" |> File.read!() |> first_part() === 64
  end

  test "example for the second part" do
    assert "test/support/day18/example.txt" |> File.read!() |> second_part() === 58
  end
end
