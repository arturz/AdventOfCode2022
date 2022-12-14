defmodule AdventOfCode2022.Day14Test do
  use ExUnit.Case

  import AdventOfCode2022.Day14

  test "example for the first part" do
    assert "test/support/day14/example.txt" |> File.read!() |> first_part() === 24
  end

  test "example for the second part" do
    assert "test/support/day14/example.txt" |> File.read!() |> second_part() === 93
  end
end
