defmodule AdventOfCode2022.Day10Test do
  use ExUnit.Case

  import AdventOfCode2022.Day10

  test "example for the first part" do
    assert "test/support/day10/example.txt" |> File.read!() |> first_part() === 13140
  end

  test "example for the second part" do
    assert "test/support/day10/example.txt"
           |> File.read!()
           |> second_part() ===
             "##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
"
  end
end
