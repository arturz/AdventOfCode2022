defmodule Utils.Stack do
  @enforce_keys [:list]
  defstruct list: []

  @type t :: %__MODULE__{
          :list => list()
        }

  @spec new :: __MODULE__.t()
  def new do
    %__MODULE__{list: []}
  end

  @spec push(__MODULE__.t(), any()) :: __MODULE__.t()
  def push(%__MODULE__{list: list} = stack, value) do
    %__MODULE__{
      stack
      | list: [value | list]
    }
  end

  @spec push_list(__MODULE__.t(), list()) :: __MODULE__.t()
  def push_list(%__MODULE__{list: list} = stack, values) do
    %__MODULE__{
      stack
      | list: values |> Enum.reverse() |> Enum.concat(list)
    }
  end

  @spec pop(__MODULE__.t()) :: {any(), __MODULE__.t()}
  def pop(%__MODULE__{list: []} = stack), do: {nil, stack}

  def pop(%__MODULE__{list: [item | rest]}) do
    {item, %__MODULE__{list: rest}}
  end

  @spec pop(__MODULE__.t(), integer()) :: {any(), __MODULE__.t()}
  def pop(%__MODULE__{list: []} = stack, _n), do: pop(stack)

  def pop(%__MODULE__{list: list}, n) do
    {Enum.take(list, n), %__MODULE__{list: Enum.drop(list, n)}}
  end

  @spec top(__MODULE__.t()) :: any()
  def top(%__MODULE__{list: []}), do: nil

  def top(%__MODULE__{list: [item | _]}), do: item
end
