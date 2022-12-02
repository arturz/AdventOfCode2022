defmodule AdventOfCode2022.Day02 do
  @moduledoc false

  @rock ["A", "X"]
  @paper ["B", "Y"]
  @scissors ["C", "Z"]

  @type move :: {String.t(), String.t()}

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> get_moves()
    |> get_overall_score()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    input
    |> get_moves()
    |> Enum.map(&fix_tinkered_move/1)
    |> get_overall_score()
  end

  @spec get_moves(String.t()) :: list(tuple())
  defp get_moves(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&split_into_tuple(&1, " "))
  end

  @spec split_into_tuple(String.t(), String.t()) :: move()
  defp split_into_tuple(binary, pattern) do
    String.split(binary, pattern)
    |> List.to_tuple()
  end

  @spec get_overall_score(list(move())) :: integer()
  defp get_overall_score(moves) do
    Enum.reduce(
      moves,
      0,
      fn move, score ->
        score + get_outcome_score(move) + get_shape_score(move)
      end
    )
  end

  @spec get_outcome_score(move()) :: integer()

  # win
  defp get_outcome_score({opponent, player})
       when (player in @rock and opponent in @scissors) or
              (player in @paper and opponent in @rock) or
              (player in @scissors and opponent in @paper),
       do: 6

  # draw
  defp get_outcome_score({opponent, player})
       when (player in @rock and opponent in @rock) or
              (player in @paper and opponent in @paper) or
              (player in @scissors and opponent in @scissors),
       do: 3

  # lost
  defp get_outcome_score(_), do: 0

  @spec get_shape_score(move()) :: integer()

  # rock
  defp get_shape_score({_, player})
       when player in @rock,
       do: 1

  # paper
  defp get_shape_score({_, player})
       when player in @paper,
       do: 2

  # scissors
  defp get_shape_score({_, player})
       when player in @scissors,
       do: 3

  @spec fix_tinkered_move(move()) :: move()

  # player needs to lose
  defp fix_tinkered_move({opponent, "X"}) when opponent in @rock,
    do: {opponent, List.first(@scissors)}

  defp fix_tinkered_move({opponent, "X"}) when opponent in @paper,
    do: {opponent, List.first(@rock)}

  defp fix_tinkered_move({opponent, "X"}) when opponent in @scissors,
    do: {opponent, List.first(@paper)}

  # player needs to end round in a draw
  defp fix_tinkered_move({opponent, "Y"}),
    do: {opponent, opponent}

  # player needs to win
  defp fix_tinkered_move({opponent, "Z"}) when opponent in @rock,
    do: {opponent, List.first(@paper)}

  defp fix_tinkered_move({opponent, "Z"}) when opponent in @paper,
    do: {opponent, List.first(@scissors)}

  defp fix_tinkered_move({opponent, "Z"}) when opponent in @scissors,
    do: {opponent, List.first(@rock)}
end
