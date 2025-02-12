defmodule FreelancerRates do
  @working_hours 8.0
  @billable_days 22

  def daily_rate(hourly_rate) do
    hourly_rate * @working_hours
  end

  def apply_discount(before_discount, discount) do
    before_discount - before_discount * (discount / 100)
  end

  def monthly_rate(hourly_rate, discount) do
    (daily_rate(hourly_rate) * @billable_days)
    |> apply_discount(discount)
    |> Float.ceil(0)
    |> trunc()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    daily_rate(hourly_rate)
    |> apply_discount(discount)
    |> days_in_budget(budget)
    |> Float.floor(1)
  end

  defp days_in_budget(rate, budget) do
    budget / rate
  end
end
