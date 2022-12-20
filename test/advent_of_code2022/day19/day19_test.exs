defmodule AdventOfCode2022.Day19Test do
  use ExUnit.Case

  import AdventOfCode2022.Day19

  @tag timeout: :infinity
  test "example for the first part" do
    assert "test/support/day19/example.txt" |> File.read!() |> first_part() === 33
  end
end
