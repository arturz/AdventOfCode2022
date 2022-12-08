defmodule AdventOfCode2022.Day08 do
  @moduledoc false

  @type tree :: %{
          x: integer(),
          y: integer(),
          height: integer()
        }

  @type matrix :: list(list(tree()))

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> get_trees_matrix()
    |> count_visible_trees_from_the_ground()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    trees_matrix = get_trees_matrix(input)

    trees_matrix
    |> :lists.flatten()
    |> Enum.map(&get_tree_scenic_score(trees_matrix, &1))
    |> Enum.sort(:desc)
    |> List.first()
  end

  @spec get_trees_matrix(String.t()) :: matrix()
  def get_trees_matrix(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {height, x} ->
        height
        |> String.to_integer()
        |> then(&%{x: x, y: y, height: &1})
      end)
    end)
  end

  @spec count_visible_trees_from_the_ground(matrix()) :: integer()
  def count_visible_trees_from_the_ground(matrix) do
    0..3
    |> Enum.reduce(MapSet.new(), fn rotate_n_times, union ->
      Enum.reduce(0..rotate_n_times, matrix, fn _, matrix -> rotate(matrix) end)
      |> Enum.map(&filter_visible_trees(&1))
      |> :lists.flatten()
      |> MapSet.new()
      |> MapSet.union(union)
    end)
    |> MapSet.size()
  end

  @spec filter_visible_trees(list(tree())) :: list(tree())
  def filter_visible_trees(trees) do
    trees
    |> Enum.reduce({-1, []}, fn tree, {highest_tree, filtered} ->
      if tree.height > highest_tree do
        {tree.height, filtered ++ [tree]}
      else
        {highest_tree, filtered}
      end
    end)
    |> elem(1)
  end

  @spec get_tree_scenic_score(matrix(), tree()) :: integer()
  def get_tree_scenic_score(matrix, tree) do
    Enum.at(matrix, tree.y)
    |> Enum.split_while(&(&1 |> Map.fetch!(:x) |> Kernel.!=(tree.x)))
    |> Tuple.to_list()
    |> Enum.map(fn view -> Enum.filter(view, &(&1 |> Map.fetch!(:x) |> Kernel.!=(tree.x))) end)
    |> then(fn [west, east] -> [Enum.reverse(west), east] end)
    |> Enum.concat(
      matrix
      |> transpose()
      |> Enum.at(tree.x)
      |> Enum.split_while(&(&1 |> Map.fetch!(:y) |> Kernel.!=(tree.y)))
      |> Tuple.to_list()
      |> Enum.map(fn view -> Enum.filter(view, &(&1 |> Map.fetch!(:y) |> Kernel.!=(tree.y))) end)
      |> then(fn [north, south] -> [Enum.reverse(north), south] end)
    )
    |> Enum.map(fn view ->
      view
      |> filter_trees_within_viewing_distance(tree.height)
      |> Enum.count()
    end)
    |> Enum.product()
  end

  @spec filter_trees_within_viewing_distance(list(tree()), integer()) :: list(tree())
  def filter_trees_within_viewing_distance(trees, height) do
    Enum.reduce_while(trees, [], fn tree, filtered ->
      if tree.height < height, do: {:cont, filtered ++ [tree]}, else: {:halt, filtered ++ [tree]}
    end)
  end

  @spec rotate(matrix()) :: matrix()
  defp rotate(matrix) do
    matrix
    |> Enum.map(&Enum.reverse/1)
    |> transpose()
  end

  @spec transpose(matrix()) :: matrix()
  defp transpose(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
