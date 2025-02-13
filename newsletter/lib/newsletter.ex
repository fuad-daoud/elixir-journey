defmodule Newsletter do
  def read_emails(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.filter(fn x -> x != "" end)
  end

  def open_log(path) do
    File.open!(path, [:write])
  end

  def log_sent_email(pid, email) do
    IO.puts(pid, email)
  end

  def close_log(pid) do
    File.close(pid)
  end

  def send_newsletter(emails_path, log_path, send_fun) do
    pid =
      log_path
      |> open_log()

    pid
    |> IO.write("")

    emails_path
    |> read_emails()
    |> Enum.each(fn x ->
      if send_fun.(x) == :ok do
        pid
        |> log_sent_email(x)
      end
    end)

    pid
    |> close_log()
  end
end
