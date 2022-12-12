defmodule AdventOfCode2022.Day12Test do
  use ExUnit.Case

  import AdventOfCode2022.Day12

  test "example for the first part" do
    assert "test/support/day12/example.txt" |> File.read!() |> first_part() === 31
  end
end
