defmodule TakeANumber do
  @moduledoc """
  module for machine state in elixir
  """

  @doc """
    this starts the machine
  """
  def start() do
    spawn(fn -> process(0) end)
  end

  defp process(state) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, state)
        process(state)

      {:take_a_number, sender_pid} ->
        send(sender_pid, state + 1)
        process(state + 1)

      :stop ->
        nil

      _ ->
        process(state)
    end
  end
end
