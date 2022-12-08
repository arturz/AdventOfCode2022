defmodule AdventOfCode2022.Day08Test do
  use ExUnit.Case

  import AdventOfCode2022.Day08

  test "example for the first part" do
    assert "test/support/day08/example.txt" |> File.read!() |> first_part() === 21
  end

  test "example for the second part" do
    assert "test/support/day08/example.txt" |> File.read!() |> second_part() === 2 * 2 * 1 * 2
  end
end
