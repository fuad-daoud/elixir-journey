defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    log2(0, 0, color_count) - 1
  end

  defp log2(value, power, number) when value >= number, do: power

  defp log2(_value, power, number) do
    log2(Integer.pow(2, power), power + 1, number)
  end

  def empty_picture() do
    ""
  end

  def test_picture() do
    <<0::2, 1::2, 2::2, 3::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    <<pixel_color_index::size(palette_bit_size(color_count)), picture::bitstring>>
  end

  def get_first_pixel(picture, _) when picture == <<0::0>>, do: nil

  def get_first_pixel(picture, color_count) do
    pixle_size = palette_bit_size(color_count)
    <<value::size(pixle_size), _::bitstring>> = <<picture::bitstring>>
    value
  end

  def drop_first_pixel(picture, _) when picture == <<0::0>>, do: picture

  def drop_first_pixel(picture, color_count) do
    pixle_size = palette_bit_size(color_count)
    <<_::size(pixle_size), rest::bitstring>> = <<picture::bitstring>>
    rest
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
