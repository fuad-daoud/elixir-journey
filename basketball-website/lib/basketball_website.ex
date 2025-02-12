defmodule BasketballWebsite do
  def extract_from_path(data, [current | []]), do: data[current]
  def extract_from_path(data, [current | path]), do: extract_from_path(data[current], path)

  def extract_from_path(data, path) do
    extract_from_path(data, String.split(path, "."))
  end

  def get_in_path(data, path) do
    Kernel.get_in(data, String.split(path, "."))
  end
end
