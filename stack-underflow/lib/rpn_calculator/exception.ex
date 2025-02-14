defmodule RPNCalculator.Exception do
  alias RPNCalculator.Exception.StackUnderflowError
  alias RPNCalculator.Exception.DivisionByZeroError

  def divide(stack) when length(stack) <= 1 do
    raise StackUnderflowError, "when dividing"
  end

  def divide([0 | _rest]) do
    raise DivisionByZeroError
  end

  def divide([first | [second | _]]) do
    div(second, first)
  end

  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"

    def exception() do
      %DivisionByZeroError{}
    end
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    def exception(value) when length(value) == 0 do
      %StackUnderflowError{}
    end

    def exception(value) do
      %StackUnderflowError{message: "stack underflow occurred, context: #{value}"}
    end
  end
end
