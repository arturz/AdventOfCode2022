defmodule AdventOfCode2022.Day20Test do
  use ExUnit.Case

  import AdventOfCode2022.Day20

  test "example for the first part" do
    assert "test/support/day20/example.txt" |> File.read!() |> first_part() === 3
  end

  test "example for the second part" do
    assert "test/support/day20/example.txt" |> File.read!() |> second_part() === 1_623_178_306
  end
end
