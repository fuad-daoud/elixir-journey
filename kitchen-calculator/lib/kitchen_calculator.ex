defmodule KitchenCalculator do
  @milliliter_conversion %{
    milliliter: 1,
    cup: 240,
    fluid_ounce: 30,
    teaspoon: 5,
    tablespoon: 15
  }

  def get_volume(volume_pair) do
    elem(volume_pair, 1)
  end

  def to_milliliter(volume_pair) do
    case volume_pair do
      {:milliliter, _} ->
        {:milliliter, get_volume(volume_pair)}

      {:cup, _} ->
        {:milliliter, get_volume(volume_pair) * @milliliter_conversion.cup}

      {:fluid_ounce, _} ->
        {:milliliter, get_volume(volume_pair) * @milliliter_conversion.fluid_ounce}

      {:teaspoon, _} ->
        {:milliliter, get_volume(volume_pair) * @milliliter_conversion.teaspoon}

      {:tablespoon, _} ->
        {:milliliter, get_volume(volume_pair) * @milliliter_conversion.tablespoon}
    end
  end

  def from_milliliter(volume_pair, unit) do
    case unit do
      :milliliter -> {unit, get_volume(volume_pair)}
      :cup -> {:cup, get_volume(volume_pair) / @milliliter_conversion.cup}
      :fluid_ounce -> {unit, get_volume(volume_pair) / @milliliter_conversion.fluid_ounce}
      :teaspoon -> {unit, get_volume(volume_pair) / @milliliter_conversion.teaspoon}
      :tablespoon -> {unit, get_volume(volume_pair) / @milliliter_conversion.tablespoon}
    end
  end

  def convert(volume_pair, unit) do
    to_milliliter(volume_pair)
    |> from_milliliter(unit)
  end
end
