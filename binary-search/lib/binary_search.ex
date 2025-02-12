defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _), do: :not_found

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    left = 0
    right = tuple_size(numbers) - 1
    search(numbers, key, left, get_mid(left, right), right)
  end

  @spec search(tuple, integer, integer, integer, integer) :: {:ok, integer} | :not_found
  defp search(_, _, left, _, right) when left > right, do: :not_found

  defp search(numbers, key, left, mid, right) do
    current = elem(numbers, mid)

    cond do
      key < current ->
        right = mid - 1
        search(numbers, key, left, get_mid(left, right), right)

      key > current ->
        left = mid + 1
        search(numbers, key, left, get_mid(left, right), right)

      true ->
        {:ok, mid}
    end
  end

  defp get_mid(left, right), do: trunc((left + right) / 2)
end
