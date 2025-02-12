defmodule Username do
  def sanitize([]) do
    ~c""
  end

  def sanitize([first_letter | rest]) do
    cleaned =
      case first_letter do
        ?ä ->
          ~c"ae"

        ?ö ->
          ~c"oe"

        ?ü ->
          ~c"ue"

        ?ß ->
          ~c"ss"

        ?_ ->
          ~c"_"

        first_letter when first_letter in ?a..?z ->
          [first_letter]

        _ ->
          ~c""
      end

    cleaned ++ sanitize(rest)
  end
end
