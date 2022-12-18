defmodule AdventOfCode2022.Day17Test do
  use ExUnit.Case

  import AdventOfCode2022.Day17

  test "example for the first part" do
    assert "test/support/day17/example.txt" |> File.read!() |> first_part() === 3068
  end

  test "example for the second part" do
    assert "test/support/day17/example.txt" |> File.read!() |> second_part() === 1_514_285_714_288
  end
end
