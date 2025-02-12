defmodule LogParser do
  def valid_line?(line) do
    String.match?(line, ~r/\A(\[INFO\]|\[ERROR\]|\[WARNING\]|\[TRACE\]|\[DEBUG\]|\[FATAL\])/)
  end

  def split_line(line) do
    String.split(line, ~r/<[-*=~]*>/)
  end

  def remove_artifacts(line) do
    String.replace(line, ~r/(?i)end-of-line\d+/, "")
  end

  def tag_with_user_name(line) do
    case Regex.run(~r/User\s+(\S+)/, line) do
      [_, username] -> "[USER] #{username} " <> line
      _ -> line
    end
  end
end
