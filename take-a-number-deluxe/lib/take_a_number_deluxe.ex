defmodule TakeANumberDeluxe do
  use GenServer
  alias TakeANumberDeluxe.State, as: State

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(opt) do
    min_number = Keyword.get(opt, :min_number)
    max_number = Keyword.get(opt, :max_number)

    cond do
      not is_integer(min_number) or not is_integer(max_number) ->
        {:error, :invalid_configuration}

      min_number > max_number ->
        {:error, :invalid_configuration}

      true ->
        GenServer.start_link(__MODULE__, opt)
    end
  end

  @impl GenServer
  def init(opt) do
    min_number = Keyword.get(opt, :min_number)
    max_number = Keyword.get(opt, :max_number)
    auto_shutdown_timeout = Keyword.get(opt, :auto_shutdown_timeout, :infinity)
    {_, state} = State.new(min_number, max_number, auto_shutdown_timeout)

    {:ok, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def handle_info(_, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call({:report}, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call({:push}, _from, state) do
    case State.queue_new_number(state) do
      {_, number, new_state} ->
        {:reply, {:ok, number}, new_state, new_state.auto_shutdown_timeout}

      {:error, msg} ->
        {:reply, {:error, msg}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve, priority}, _from, state) do
    case State.serve_next_queued_number(state, priority) do
      {_, number, new_state} ->
        {:reply, {:ok, number}, new_state, new_state.auto_shutdown_timeout}

      {:error, msg} ->
        {:reply, {:error, msg}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:reset}, _from, state) do
    {_, state} = State.new(state.min_number, state.max_number, state.auto_shutdown_timeout)

    {:reply, :ok, state, state.auto_shutdown_timeout}
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, {:report})
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, {:push})
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.call(machine, {:reset})
  end
end
