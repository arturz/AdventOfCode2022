defmodule AdventOfCode2022.Day20 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    file =
      input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> then(fn file ->
        Enum.reduce(file, file, fn {number, index}, file ->
          position = Enum.find_index(file, &(elem(&1, 1) == index))

          # raw_next_position = positioąn + number
          # next_position = get_next_position(raw_next_position, length(file))
          next_position =
            if position + number < 0 do
              rem(position + number - 1, length(file) - 1)
            else
              rem(position + number, length(file) - 1)
            end

          file
          |> List.delete_at(position)
          |> List.insert_at(next_position, {number, index})
          |> tap(fn x ->
            x
            |> Enum.map(&elem(&1, 0))
            |> IO.inspect()
          end)
        end)
      end)
      |> Enum.map(&elem(&1, 0))

    zero_position = Enum.find_index(file, &(&1 === 0))

    a = Enum.at(file, rem(zero_position + 1000, length(file)))
    b = Enum.at(file, rem(zero_position + 2000, length(file)))
    c = Enum.at(file, rem(zero_position + 3000, length(file)))
    a + b + c
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    file =
      input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&(&1 * 811_589_153))
      |> Enum.with_index()
      |> then(fn file ->
        Enum.reduce(1..10, file, fn _, file ->
          Enum.reduce(file, file, fn {number, index}, file ->
            position = Enum.find_index(file, &(elem(&1, 1) == index))

            raw_next_position = position + number

            next_position = get_next_position(raw_next_position, length(file))

            file
            |> List.delete_at(position)
            |> List.insert_at(next_position, {number, index})
          end)
        end)
      end)
      |> Enum.map(&elem(&1, 0))

    zero_position = Enum.find_index(file, &(&1 === 0))

    a = Enum.at(file, rem(zero_position + 1000, length(file)))
    b = Enum.at(file, rem(zero_position + 2000, length(file)))
    c = Enum.at(file, rem(zero_position + 3000, length(file)))
    a + b + c
  end

  defp get_next_position(raw_next_position, length) do
    case raw_next_position do
      0 -> length - 1
      raw_next_position when raw_next_position < 0 -> length + raw_next_position - 1
      raw_next_position when raw_next_position >= length -> rem(raw_next_position, length) + 1
      raw_next_position -> raw_next_position
    end
  end
end
