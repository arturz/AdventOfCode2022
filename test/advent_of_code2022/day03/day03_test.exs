defmodule AdventOfCode2022.Day03Test do
  use ExUnit.Case

  import AdventOfCode2022.Day03

  test "example" do
    assert "test/support/day03/example.txt" |> File.read!() |> first_part() === 157
  end
end
