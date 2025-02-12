defmodule NameBadge do
  def print(id, name, department) do
    dep = if department, do: String.upcase(department), else: "OWNER"
    id_text = if id, do: "[#{id}] - ", else: ""
    "#{id_text}#{name} - #{dep}"
  end
end
