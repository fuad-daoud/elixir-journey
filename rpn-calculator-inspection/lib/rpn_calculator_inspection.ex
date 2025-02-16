defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid =
      spawn_link(fn ->
        Process.flag(:trap_exit, true)
        calculator.(input)
      end)

    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results \\ %{}) do
    res =
      receive do
        {:EXIT, ^pid, :normal} ->
          :ok

        {:EXIT, ^pid, _} ->
          :error
      after
        100 -> :timeout
      end

    Map.put(results, input, res)
  end

  def reliability_check(calculator, inputs) do
    old = Process.flag(:trap_exit, true)

    output =
      inputs
      |> Enum.map(fn input ->
        start_reliability_check(calculator, input)
      end)
      |> Enum.reduce(%{}, fn data, acc ->
        await_reliability_check_result(data, acc)
      end)

    Process.flag(:trap_exit, old)
    output
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(fn input ->
      Task.async(fn -> calculator.(input) end)
    end)
    |> Task.await_many(100)
  end
end
