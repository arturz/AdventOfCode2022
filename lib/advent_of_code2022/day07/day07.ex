defmodule AdventOfCode2022.Day07 do
  @moduledoc false

  @spec first_part(String.t()) :: integer()
  def first_part(input) do
    input
    |> parse_for_sizes_of_directories()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  @spec second_part(String.t()) :: integer()
  def second_part(input) do
    sorted_sizes_of_directories =
      input
      |> parse_for_sizes_of_directories()
      |> Enum.sort()

    sorted_sizes_of_directories
    |> Enum.filter(&(&1 >= 30_000_000 - (70_000_000 - List.last(sorted_sizes_of_directories))))
    |> List.first()
  end

  @spec parse_for_sizes_of_directories(String.t()) :: list(integer())
  def parse_for_sizes_of_directories(input) do
    input
    |> String.split("$", trim: true)
    |> Enum.map(&(&1 |> String.trim() |> String.split("\n")))
    |> build_filetree()
    |> get_sizes_of_directories()
    |> Map.values()
  end

  # The first idea I've got, can be reduced to map with directories as keys and sizes as values.
  @spec build_filetree(list(list(String.t()))) :: map()
  def build_filetree(input) do
    input
    |> Enum.reduce({%{}, []}, fn
      ["cd /"], {tree, _} ->
        {tree, []}

      ["cd .."], {tree, cwd} ->
        {tree, Enum.drop(cwd, -1)}

      [<<"cd ", arg::binary>>], {tree, cwd} ->
        {tree, cwd ++ [arg]}

      ["ls" | args], {tree, cwd} ->
        args
        |> Enum.map(&String.split(&1, " "))
        |> Enum.map(fn
          ["dir", dir_name] -> {dir_name, %{}}
          [file_size, file_name] -> {file_name, String.to_integer(file_size)}
        end)
        |> Map.new()
        |> then(fn map_with_cwd_entries ->
          case cwd do
            [] -> {map_with_cwd_entries, cwd}
            cwd -> {put_in(tree, cwd, map_with_cwd_entries), cwd}
          end
        end)
    end)
    |> elem(0)
  end

  @spec get_sizes_of_directories(map(), list()) :: %{list() => integer()}
  @spec get_sizes_of_directories(map()) :: %{list() => integer()}
  def get_sizes_of_directories(tree, cwd \\ []) do
    map_with_cwd_entries = if cwd == [], do: tree, else: get_in(tree, cwd)

    directories =
      map_with_cwd_entries
      |> Enum.to_list()
      |> Enum.filter(&(&1 |> elem(1) |> is_map()))
      |> Enum.map(&elem(&1, 0))

    files_size =
      map_with_cwd_entries
      |> Enum.to_list()
      |> Enum.reject(&(&1 |> elem(1) |> is_map()))
      |> Enum.map(&elem(&1, 1))
      |> Enum.sum()

    {sizes_of_directories, files_and_directories_size} =
      Enum.reduce(directories, {%{}, files_size}, fn dirname,
                                                     {sizes_of_directories,
                                                      files_and_directories_size} ->
        new_cwd = cwd ++ [dirname]
        new_sizes_of_directories = get_sizes_of_directories(tree, new_cwd)

        sizes_of_directories
        |> Map.merge(new_sizes_of_directories)
        |> List.wrap()
        |> List.to_tuple()
        |> Tuple.append(files_and_directories_size + Map.get(new_sizes_of_directories, new_cwd))
      end)

    Map.put(sizes_of_directories, cwd, files_and_directories_size)
  end
end
