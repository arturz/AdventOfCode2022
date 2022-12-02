defmodule AdventOfCode2022.Day02Test do
  use ExUnit.Case

  import AdventOfCode2022.Day02

  test "example" do
    assert "test/support/day02/example.txt" |> File.read!() |> first_part() === 15
  end
end
