defmodule AdventOfCode2022.Day05Test do
  use ExUnit.Case

  import AdventOfCode2022.Day05

  test "example" do
    assert "test/support/day05/example.txt" |> File.read!() |> first_part() === "CMZ"
  end

  test "example2" do
    assert "test/support/day05/example.txt" |> File.read!() |> second_part() === "MCD"
  end
end
