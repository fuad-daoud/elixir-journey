defmodule FileSniffer do
  @media_types %{
    :exe => "application/octet-stream",
    :bmp => "image/bmp",
    :png => "image/png",
    :jpg => "image/jpg",
    :gif => "image/gif"
  }

  def type_from_extension(extension) do
    case extension do
      "exe" -> "application/octet-stream"
      ext when ext in ["bmp", "png", "jpg", "gif"] -> "image/#{extension}"
      _ -> nil
    end
  end

  def type_from_binary(file_binary) do
    case file_binary do
      <<0x42, 0x4D, _::binary>> -> @media_types.bmp
      <<0xFF, 0xD8, 0xFF, _::binary>> -> @media_types.jpg
      <<0x47, 0x49, 0x46, _::binary>> -> @media_types.gif
      <<0x7F, 0x45, 0x4C, 0x46, _::binary>> -> @media_types.exe
      <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>> -> @media_types.png
      _ -> nil
    end
  end

  def verify(file_binary, extension) do
    ext = type_from_extension(extension)

    if type_from_binary(file_binary) == ext and ext != nil do
      {:ok, ext}
    else
      {:error, "Warning, file format and file extension do not match."}
    end
  end
end
