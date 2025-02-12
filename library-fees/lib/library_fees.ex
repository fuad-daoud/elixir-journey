defmodule LibraryFees do
  @noon 12
  @discount 0.5

  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(datetime) do
    datetime.hour < @noon
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

    days =
      checkout
      |> return_date()
      |> days_late(return)

    if monday?(return) do
      floor(rate * days * @discount)
    else
      rate * days
    end
  end
end
