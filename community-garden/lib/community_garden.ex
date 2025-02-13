# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start_link(fn -> {0, []} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn {_, plots} -> plots end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn {count, plots} ->
      plot = %Plot{plot_id: count + 1, registered_to: register_to}
      {plot, {count + 1, [plot | plots]}}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn {count, plots} ->
      new_plots =
        Enum.filter(plots, fn plot ->
          plot.plot_id != plot_id
        end)

      {count, new_plots}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn {_, plots} ->
      plots
      |> Enum.filter(fn plot -> plot.plot_id == plot_id end)
      |> List.first({:not_found, "plot is unregistered"})
    end)
  end
end
