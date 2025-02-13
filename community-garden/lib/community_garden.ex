# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  use Agent

  def start(opts \\ []) do
    Agent.start_link(fn -> %{count: 0, plots: []} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn state -> state.plots end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn state ->
      plot = %Plot{plot_id: state.count + 1, registered_to: register_to}
      {plot, %{count: state.count + 1, plots: [plot | state.plots]}}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn state ->
      plots =
        Enum.filter(state.plots, fn plot ->
          plot.plot_id != plot_id
        end)

      %{count: state.count, plots: plots}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn state ->
      state.plots
      |> Enum.filter(fn plot -> plot.plot_id == plot_id end)
      |> List.first({:not_found, "plot is unregistered"})
    end)
  end
end
