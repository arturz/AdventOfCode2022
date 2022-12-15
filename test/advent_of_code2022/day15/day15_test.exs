defmodule AdventOfCode2022.Day15Test do
  use ExUnit.Case

  import AdventOfCode2022.Day15

  test "example for the first part" do
    assert "test/support/day15/example.txt" |> File.read!() |> first_part(10) === 26
  end
end
