defmodule Mix.Tasks.Day do
  @moduledoc false

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    day =
      args
      |> List.first()
      |> String.pad_leading(2, "0")

    part = if List.last(args) === "2", do: "second", else: "first"

    input = File.read!("test/support/day#{day}/input.txt")

    "Elixir.AdventOfCode2022.Day#{day}"
    |> String.to_atom()
    |> apply(String.to_atom("#{part}_part"), [input])
    |> IO.inspect()
  end
end
