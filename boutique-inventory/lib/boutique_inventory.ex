defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort_by(
      inventory,
      fn a -> a[:price] end,
      :asc
    )
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, fn i -> i[:price] == nil end)
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn i ->
      if String.match?(i[:name], ~r/#{old_word}/) do
        %{i | name: String.replace(i[:name], ~r/#{old_word}/, new_word)}
      else
        i
      end
    end)
  end

  def increase_quantity(item, count) do
    q = item.quantity_by_size

    %{
      item
      | quantity_by_size: Enum.into(q, %{}, fn {k, v} -> {k, v + count} end)
    }
  end

  def total_quantity(item) when item.quantity_by_size == %{}, do: 0

  def total_quantity(item) do
    Enum.reduce(Map.values(item.quantity_by_size), fn x, acc -> x + acc end)
  end
end
