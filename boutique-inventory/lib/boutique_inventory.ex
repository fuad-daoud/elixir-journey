defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort_by(
      inventory,
      & &1.price,
      :asc
    )
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, &(!&1.price))
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn item ->
      %{item | name: String.replace(item.name, old_word, new_word)}
    end)
  end

  def increase_quantity(item, count) do
    %{
      item
      | quantity_by_size:
          item.quantity_by_size
          |> Enum.into(%{}, fn {k, v} -> {k, v + count} end)
    }
  end

  def total_quantity(item) when item.quantity_by_size == %{}, do: 0

  def total_quantity(%{quantity_by_size: sizes}) do
    sizes
    |> Map.values()
    |> Enum.reduce(fn x, acc -> x + acc end)
  end
end
