defmodule AdventOfCode2022.Day01Test do
  use ExUnit.Case

  import AdventOfCode2022.Day01

  test "example" do
    assert "test/support/day01/example.txt" |> File.read!() |> first_part() === 24000
  end
end
