defmodule FileSniffer do
  @media_types %{
    :exe => "application/octet-stream",
    :bmp => "image/bmp",
    :png => "image/png",
    :jpg => "image/jpg",
    :gif => "image/gif"
  }

  @media_binary %{
    :exe => <<0x7F, 0x45, 0x4C, 0x46>>,
    :bmp => <<0x42, 0x4D>>,
    :png => <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>,
    :jpg => <<0xFF, 0xD8, 0xFF>>,
    :gif => <<0x47, 0x49, 0x46>>
  }

  def type_from_extension(extension) do
    case extension do
      "exe" -> "application/octet-stream"
      ext when ext in ["bmp", "png", "jpg", "gif"] -> "image/#{extension}"
      _ -> nil
    end
  end

  def type_from_binary(file_binary) do
    cond do
      get_header(file_binary, 2) == @media_binary.bmp -> @media_types.bmp
      get_header(file_binary, 3) == @media_binary.jpg -> @media_types.jpg
      get_header(file_binary, 3) == @media_binary.gif -> @media_types.gif
      get_header(file_binary, 4) == @media_binary.exe -> @media_types.exe
      get_header(file_binary, 8) == @media_binary.png -> @media_types.png
      true -> nil
    end
  end

  defp get_header(file_binary, bytes) do
    if !is_binary(file_binary) or byte_size(file_binary) < bytes do
      nil
    else
      <<header::binary-size(bytes), _::binary>> = file_binary
      header
    end
  end

  def verify(file_binary, extension) do
    ext = type_from_extension(extension)
    binary_ext = type_from_binary(file_binary)

    if binary_ext == ext and ext != nil do
      {:ok, ext}
    else
      {:error, "Warning, file format and file extension do not match."}
    end
  end
end
