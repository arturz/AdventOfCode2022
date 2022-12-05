defmodule Utils.QueueTest do
  use ExUnit.Case

  alias Utils.Queue

  setup do
    %{queue: Queue.new()}
  end

  test "enqueue and dequeue work properly", %{queue: queue} do
    queue =
      queue
      |> Queue.enqueue(1)
      |> Queue.enqueue(2)
      |> Queue.enqueue(3)

    {1, queue} = Queue.dequeue(queue)
    {2, queue} = Queue.dequeue(queue)
    {3, _queue} = Queue.dequeue(queue)
  end

  test "enqueue_list and dequeuing multiple values work properly", %{queue: queue} do
    queue = Queue.enqueue_list(queue, [1, 2, 3, 4])
    {[1, 2, 3, 4], _queue} = Queue.dequeue(queue, 4)
  end

  test "top works properly", %{queue: queue} do
    queue = Queue.enqueue_list(queue, [1, 2, 3, 4])
    assert Queue.top(queue) === 1
  end
end
