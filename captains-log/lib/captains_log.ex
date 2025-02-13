defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class() do
    Enum.random(@planetary_classes)
  end

  def random_ship_registry_number() do
    "NCC-#{Enum.random(1_000..9999)}"
  end

  def random_stardate() do
    Enum.random(4_100_000..4_200_000) / 100
  end

  def format_stardate(stardate) do
    :erlang.float_to_binary(stardate, decimals: 1)
  end
end
