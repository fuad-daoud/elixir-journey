defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part({op, _, rest} = ast, acc) when op in [:def, :defp],
    do: {ast, [decode(rest) | acc]}

  def decode_secret_message_part(ast, acc), do: {ast, acc}
  defp decode([{:when, _, rest} | _]), do: decode(rest)
  defp decode([{_, _, nil} | _]), do: ""
  defp decode([{fun, _, args} | _]), do: String.slice(Kernel.to_string(fun), 0, length(args))

  def decode_secret_message(string) do
    ast = to_ast(string)

    {_, acc} = Macro.prewalk(ast, [], &decode_secret_message_part/2)

    acc
    |> Enum.reverse()
    |> Enum.join("")
  end
end
