defmodule LibraryFees do
  def datetime_from_string(string) do
    {_, d} =
      string
      |> String.replace("T", " ")
      |> String.replace("Z", "")
      |> NaiveDateTime.from_iso8601()

    d
  end

  def before_noon?(datetime) do
    datetime
    |> NaiveDateTime.to_time()
    |> Time.before?(~T[12:00:00])
  end

  def return_date(checkout_datetime) do
    if before_noon?(checkout_datetime) do
      checkout_datetime
      |> NaiveDateTime.to_date()
      |> Date.add(28)
    else
      checkout_datetime
      |> NaiveDateTime.to_date()
      |> Date.add(29)
    end
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> max(0)
  end

  def monday?(datetime) do
    day =
      datetime
      |> NaiveDateTime.to_date()
      |> Date.day_of_week()

    day == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    checkout = checkout |> datetime_from_string()
    return = return |> datetime_from_string()
    days = days_late(checkout, return)

    {_, expected_date} =
      checkout
      |> return_date()
      |> NaiveDateTime.new(~T[00:00:00])

    expected_days = days_late(checkout, expected_date)

    case {days, before_noon?(checkout)} do
      {x, _} when x <= 28 ->
        0

      {29, true} ->
        rate

      {29, false} ->
        0

      {30, false} ->
        rate

      {_, _} ->
        if monday?(return),
          do: div(rate * (days - expected_days), 2),
          else: rate * (days - expected_days)
    end
  end
end
