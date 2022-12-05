defmodule Utils.StackTest do
  use ExUnit.Case

  alias Utils.Stack

  setup do
    %{stack: Stack.new()}
  end

  test "push and pop work properly", %{stack: stack} do
    stack =
      stack
      |> Stack.push(1)
      |> Stack.push(2)
      |> Stack.push(3)

    {3, stack} = Stack.pop(stack)
    {2, stack} = Stack.pop(stack)
    {1, _stack} = Stack.pop(stack)
  end

  test "push_list and popping multiple values work properly", %{stack: stack} do
    stack = Stack.push_list(stack, [1, 2, 3, 4])
    {[4, 3, 2, 1], _stack} = Stack.pop(stack, 4)
  end

  test "top works properly", %{stack: stack} do
    stack = Stack.push_list(stack, [1, 2, 3, 4])
    assert Stack.top(stack) === 4
  end
end
