defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer
  @callback init(options :: opts) :: {:ok, opts :: opts} | {:error, error}

  @callback handle_frame(dot :: dot, frame_number :: integer, options :: opts) :: dot

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(options) do
        {:ok, options}
      end

      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation
  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _options) when rem(frame_number, 4) != 0, do: dot
  @impl DancingDots.Animation
  def handle_frame(%DancingDots.Dot{opacity: opacity} = dot, _frame_number, _options) do
    %DancingDots.Dot{dot | opacity: opacity * 0.5}
  end
end

defmodule DancingDots.Zoom do
  @behaviour DancingDots.Animation

  @impl DancingDots.Animation
  def init(options) do
    if not Keyword.has_key?(options, :velocity) do
      {:error, "The :velocity option is required, and its value must be a number. Got: nil"}
    else
      velocity = Keyword.get(options, :velocity)

      if is_integer(velocity) do
        {:ok, options}
      else
        {:error,
         "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}
      end
    end
  end

  @impl DancingDots.Animation
  def handle_frame(%DancingDots.Dot{radius: radius} = dot, frame_number, options) do
    %DancingDots.Dot{dot | radius: radius + (frame_number - 1) * Keyword.get(options, :velocity)}
  end
end
