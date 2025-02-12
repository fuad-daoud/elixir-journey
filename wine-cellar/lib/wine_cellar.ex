defmodule WineCellar do
  def explain_colors do
    [
      white: "Fermented without skin contact.",
      red: "Fermented with skin contact using dark-colored grapes.",
      rose: "Fermented with some skin contact, but not enough to qualify as a red wine."
    ]
  end

  def filter(cellar, color, opts \\ []) do
    cellar
    |> Enum.filter(fn {k, v} ->
      options_filter =
        cond do
          length(opts) == 0 ->
            true

          opts[:year] != nil and opts[:country] != nil ->
            elem(v, 1) == opts[:year] and elem(v, 2) == opts[:country]

          opts[:year] != nil ->
            elem(v, 1) == opts[:year]

          opts[:country] != nil ->
            elem(v, 2) == opts[:country]

          true ->
            true
        end

      k == color and options_filter
    end)
    |> Enum.map(fn {_, v} -> v end)
  end

  # The functions below do not need to be modified.

  defp filter_by_year(wines, year)
  defp filter_by_year([], _year), do: []

  defp filter_by_year([{_, year, _} = wine | tail], year) do
    [wine | filter_by_year(tail, year)]
  end

  defp filter_by_year([{_, _, _} | tail], year) do
    filter_by_year(tail, year)
  end

  defp filter_by_country(wines, country)
  defp filter_by_country([], _country), do: []

  defp filter_by_country([{_, _, country} = wine | tail], country) do
    [wine | filter_by_country(tail, country)]
  end

  defp filter_by_country([{_, _, _} | tail], country) do
    filter_by_country(tail, country)
  end
end
