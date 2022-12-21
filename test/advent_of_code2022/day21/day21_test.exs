defmodule AdventOfCode2022.Day21Test do
  use ExUnit.Case

  import AdventOfCode2022.Day21

  test "example for the first part" do
    assert "test/support/day21/example.txt" |> File.read!() |> first_part() === 152
  end

  @tag timeout: :infinity
  test "example for the second part" do
    assert "test/support/day21/example.txt" |> File.read!() |> second_part() === 301
  end
end
