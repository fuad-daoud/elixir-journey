defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """

  def get_call_count, do: :persistent_term.get(:call_count)

  # :persistent_term.put(:call_count, 0)

  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value(items, maximum_weight) do
    maximum_value(items, 0, 0, maximum_weight)
  end

  def maximum_value([], value, _, _) do
    # :persistent_term.put(:call_count, :persistent_term.get(:call_count) + 1)
    value
  end

  def maximum_value([item | items], value, weight, maxi) when weight + item.weight > maxi do
    # :persistent_term.put(:call_count, :persistent_term.get(:call_count) + 1)
    weights = Process.get(length(items), %{})
    cache = Map.get(weights, weight, -1)

    cond do
      cache > value ->
        cache

      true ->
        weights = Map.put(weights, weight, value)
        Process.put(length(items), weights)
        maximum_value(items, value, weight, maxi)
    end
  end

  def maximum_value([item | items], value, weight, maxi) do
    # :persistent_term.put(:call_count, :persistent_term.get(:call_count) + 1)
    weights = Process.get(length(items), %{})
    cache = Map.get(weights, weight, -1)

    cond do
      cache > value ->
        cache

      true ->
        weights = Map.put(weights, weight, value)
        Process.put(length(items), weights)

        max(
          maximum_value(items, value + item.value, weight + item.weight, maxi),
          maximum_value(items, value, weight, maxi)
        )
    end
  end
end
