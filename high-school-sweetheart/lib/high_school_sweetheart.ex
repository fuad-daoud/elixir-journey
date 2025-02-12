defmodule HighSchoolSweetheart do
  def first_letter(name) do
    name
    |> String.trim()
    |> String.first()
  end

  def initial(name) do
    name
    |> first_letter()
    |> String.upcase()
    |> join(".")
  end

  defp join(first, second), do: first <> second

  def initials(full_name) do
    [first, second] = String.split(full_name, [" "])
    "#{initial(first)} #{initial(second)}"
  end

  def pair(full_name1, full_name2) do
    """
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    **     #{make_pair(full_name1, full_name2)}     **
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    """
  end

  defp make_pair(full_name1, full_name2) do
    "#{initials(full_name1)}  +  #{initials(full_name2)}"
  end
end
