defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """

  def get_call_count, do: :persistent_term.get(:call_count)

  :persistent_term.put(:call_count, 0)

  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value(items, maximum_weight) do
    {:ok, pid} = GenServer.start(__MODULE__, [])
    maximum_value(items, 0, 0, maximum_weight, pid)
  end

  def maximum_value([], value, _, _, _) do
    :persistent_term.put(:call_count, :persistent_term.get(:call_count) + 1)
    value
  end

  def maximum_value([item | items], value, weight, maxi, pid) when weight + item.weight > maxi do
    :persistent_term.put(:call_count, :persistent_term.get(:call_count) + 1)
    cache = GenServer.call(pid, {:report, length(items), weight})

    cond do
      cache > value ->
        cache

      true ->
        answer = maximum_value(items, value, weight, maxi, pid)
        GenServer.call(pid, {:add, length(items), weight, answer})
        answer
    end
  end

  def maximum_value([item | items], value, weight, maxi, pid) do
    :persistent_term.put(:call_count, :persistent_term.get(:call_count) + 1)
    cache = GenServer.call(pid, {:report, length(items), weight})

    cond do
      cache > value ->
        cache

      true ->
        GenServer.call(pid, {:add, length(items), weight, value})

        answer =
          max(
            maximum_value(items, value + item.value, weight + item.weight, maxi, pid),
            maximum_value(items, value, weight, maxi, pid)
          )

        answer
    end
  end

  use GenServer
  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:report, items_left, weight}, _, state) do
    x = Map.get(state, items_left, %{})
    reply = Map.get(x, weight, -1)
    {:reply, reply, state}
  end

  @impl GenServer
  def handle_call({:add, items_left, weight, value}, _, state) do
    x = Map.get(state, items_left, %{})
    x = Map.put(x, weight, value)
    state = Map.put(state, items_left, x)
    {:reply, value, state}
  end

  @impl GenServer
  def handle_call({:all}, _, state) do
    {:reply, state, state}
  end
end
