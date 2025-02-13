defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part(ast, acc) do
    case ast do
      {:def, _, _} ->
        process(ast, acc)

      {:defp, _, _} ->
        process(ast, acc)

      _ ->
        {ast, acc}
    end
  end

  defp process(ast, acc) do
    # if String.contains?(inspect(ast), "adjust"), do: IO.inspect(ast)

    {fn_name, args} =
      case ast do
        {_, _, [{:when, _, _}, _]} ->
          {_, _, [{_, _, [{fn_name, _, args}, _]}, _]} = ast
          {fn_name, args}

        _ ->
          {_, _, [{fn_name, _, args}, _]} = ast

          if args == nil do
            {fn_name, []}
          else
            {fn_name, args}
          end
      end

    fn_name =
      case length(args) do
        0 ->
          ""

        _ ->
          fn_name
          |> Atom.to_string()
          |> String.slice(0, length(args))
      end

    {ast, [fn_name | acc]}
  end

  def decode_secret_message(string) do
    ast = to_ast(string)
    functions = find_function_definitions(ast)

    functions
    |> Enum.reduce([], fn function, acc ->
      {_, x} = decode_secret_message_part(function, acc)
      x
    end)
    |> Enum.reverse()
    |> Enum.join("")
  end

  def find_function_definitions(ast) do
    ast
    |> Macro.prewalk([], fn
      {def_type, _, _} = node, acc when def_type in [:def, :defp] ->
        {node, [node | acc]}

      node, acc ->
        {node, acc}
    end)
    |> elem(1)
    |> Enum.reverse()
  end
end
