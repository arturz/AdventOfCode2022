defmodule AdventOfCode2022.Day09 do
  @moduledoc false

  @type position :: %{
          head: %{
            x: integer(),
            y: integer()
          },
          tail: %{
            x: integer(),
            y: integer()
          }
        }

  @empty_position %{x: 0, y: 0}

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> String.split("\n")
    |> Enum.reduce([%{head: @empty_position, tail: @empty_position}], &do_action(&1, &2))
    |> :lists.flatten()
    |> Enum.map(& &1.tail)
    |> MapSet.new()
    |> MapSet.size()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(
      [%{head: @empty_position, tails: Enum.map(1..9, fn _ -> @empty_position end)}],
      &do_action_with_multiple_tails(&1, &2)
    )
    |> IO.inspect()
    |> :lists.flatten()
    |> Enum.map(&(&1 |> Map.get(:tails) |> List.last()))
    |> MapSet.new()
    |> MapSet.size()
  end

  def do_action(action, positions) do
    case action do
      <<"R ", amount::binary>> ->
        Enum.reduce(1..String.to_integer(amount), positions, fn _, positions ->
          [perform_move(List.first(positions), &%{x: &1.x + 1})] ++ positions
        end)

      <<"L ", amount::binary>> ->
        Enum.reduce(1..String.to_integer(amount), positions, fn _, positions ->
          [perform_move(List.first(positions), &%{x: &1.x - 1})] ++ positions
        end)

      <<"U ", amount::binary>> ->
        Enum.reduce(1..String.to_integer(amount), positions, fn _, positions ->
          [perform_move(List.first(positions), &%{y: &1.y + 1})] ++ positions
        end)

      <<"D ", amount::binary>> ->
        Enum.reduce(1..String.to_integer(amount), positions, fn _, positions ->
          [perform_move(List.first(positions), &%{y: &1.y - 1})] ++ positions
        end)
    end
  end

  def do_action_with_multiple_tails(action, positions) do
    case action do
      <<"R ", amount::binary>> ->
        Enum.reduce(1..String.to_integer(amount), positions, fn _, positions ->
          [perform_move_with_multiple_tails(List.first(positions), &%{x: &1.x + 1})] ++ positions
        end)

      <<"L ", amount::binary>> ->
        Enum.reduce(1..String.to_integer(amount), positions, fn _, positions ->
          [perform_move_with_multiple_tails(List.first(positions), &%{x: &1.x - 1})] ++ positions
        end)

      <<"U ", amount::binary>> ->
        Enum.reduce(1..String.to_integer(amount), positions, fn _, positions ->
          [perform_move_with_multiple_tails(List.first(positions), &%{y: &1.y + 1})] ++ positions
        end)

      <<"D ", amount::binary>> ->
        Enum.reduce(1..String.to_integer(amount), positions, fn _, positions ->
          [perform_move_with_multiple_tails(List.first(positions), &%{y: &1.y - 1})] ++ positions
        end)
    end
  end

  def perform_move(%{head: latest_head, tail: latest_tail}, head_updater) do
    head = Map.merge(latest_head, head_updater.(latest_head))

    %{head: head, tail: adjust_tail(latest_tail, head)}
  end

  def perform_move_with_multiple_tails(%{head: latest_head, tails: latest_tails}, head_updater) do
    head = Map.merge(latest_head, head_updater.(latest_head))

    tails =
      latest_tails
      |> Enum.drop(1)
      |> Enum.reduce([adjust_tail(List.first(latest_tails), head)], fn tail, tails ->
        [adjust_tail(List.first(tails), tail) | tails]
      end)

    %{head: head, tails: tails}
  end

  def adjust_tail(latest_tail, head) do
    if euclidean_distance(head, latest_tail) < 2 do
      latest_tail
    else
      if abs(head.x - latest_tail.x) > abs(head.y - latest_tail.y) do
        if head.x > latest_tail.x do
          %{x: head.x - 1, y: head.y}
        else
          %{x: head.x + 1, y: head.y}
        end
      else
        if head.y > latest_tail.y do
          %{x: head.x, y: head.y - 1}
        else
          %{x: head.x, y: head.y + 1}
        end
      end
    end
  end

  defp euclidean_distance(p1, p2) do
    :math.sqrt((p1.x - p2.x) ** 2 + (p1.y - p2.y) ** 2)
  end
end
