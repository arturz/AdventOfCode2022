defmodule AdventOfCode2022.Day06Test do
  use ExUnit.Case

  import AdventOfCode2022.Day06

  test "examples for the first part" do
    assert "mjqjpqmgbljsphdztnvjfqwrcgsmlb" |> first_part() === 7
    assert "bvwbjplbgvbhsrlpgdmjqwftvncz" |> first_part() === 5
    assert "nppdvjthqldpwncqszvftbrmjlhg" |> first_part() === 6
    assert "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" |> first_part() === 10
    assert "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" |> first_part() === 11
  end

  test "examples for the second part" do
    assert "mjqjpqmgbljsphdztnvjfqwrcgsmlb" |> second_part() === 19
    assert "bvwbjplbgvbhsrlpgdmjqwftvncz" |> second_part() === 23
    assert "nppdvjthqldpwncqszvftbrmjlhg" |> second_part() === 23
    assert "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" |> second_part() === 29
    assert "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" |> second_part() === 26
  end
end
