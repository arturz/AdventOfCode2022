defmodule AdventOfCode2022.Day09Test do
  use ExUnit.Case

  import AdventOfCode2022.Day09

  test "example for the first part" do
    assert "test/support/day09/example.txt" |> File.read!() |> first_part() === 13
  end

  test "example for the second part" do
    # assert "test/support/day09/example.txt" |> File.read!() |> second_part() === 1
    # assert "test/support/day09/example2.txt" |> File.read!() |> second_part() === 36
  end
end
