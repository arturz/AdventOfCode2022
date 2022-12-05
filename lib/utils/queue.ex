defmodule Utils.Queue do
  @enforce_keys [:list]
  defstruct list: []

  @type t :: %__MODULE__{
          :list => list()
        }

  @spec new :: __MODULE__.t()
  def new do
    %__MODULE__{list: []}
  end

  @spec enqueue(__MODULE__.t(), any()) :: __MODULE__.t()
  def enqueue(%__MODULE__{list: list} = queue, value) do
    %__MODULE__{
      queue
      | list: [value | list]
    }
  end

  @spec enqueue_list(__MODULE__.t(), list()) :: __MODULE__.t()
  def enqueue_list(%__MODULE__{list: list} = queue, values) do
    %__MODULE__{
      queue
      | list: values ++ list
    }
  end

  @spec dequeue(__MODULE__.t()) :: {any(), __MODULE__.t()}
  def dequeue(%__MODULE__{list: []} = queue), do: {nil, queue}

  def dequeue(%__MODULE__{list: list}) do
    {List.last(list), %__MODULE__{list: Enum.drop(list, -1)}}
  end

  @spec dequeue(__MODULE__.t(), integer()) :: {any(), __MODULE__.t()}
  def dequeue(%__MODULE__{list: []} = queue, _n), do: dequeue(queue)

  def dequeue(%__MODULE__{list: list}, n) do
    {Enum.take(list, -n), %__MODULE__{list: Enum.drop(list, -n)}}
  end

  @spec top(__MODULE__.t()) :: any()
  def top(%__MODULE__{list: []}), do: nil

  def top(%__MODULE__{list: [item | _]}), do: item
end
