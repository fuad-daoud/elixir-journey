defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct battery_percentage: 100,
            distance_driven_in_meters: 0,
            nickname: ""

  def new() do
    %RemoteControlCar{
      battery_percentage: 100,
      distance_driven_in_meters: 0,
      nickname: "none"
    }
  end

  def new(nickname) do
    %RemoteControlCar{
      battery_percentage: 100,
      distance_driven_in_meters: 0,
      nickname: nickname
    }
  end

  def display_distance(%RemoteControlCar{
        battery_percentage: _battery_percentage,
        distance_driven_in_meters: distance_driven_in_meters,
        nickname: _nickname
      }) do
    "#{distance_driven_in_meters} meters"
  end

  def display_battery(%RemoteControlCar{
        battery_percentage: battery_percentage,
        distance_driven_in_meters: _distance_driven_in_meters,
        nickname: _nickname
      }) do
    if battery_percentage == 0 do
      "Battery empty"
    else
      "Battery at #{battery_percentage}%"
    end
  end

  def drive(%RemoteControlCar{
        battery_percentage: battery_percentage,
        distance_driven_in_meters: distance_driven_in_meters,
        nickname: nickname
      }) do
    if battery_percentage == 0 do
      %RemoteControlCar{
        battery_percentage: battery_percentage,
        distance_driven_in_meters: distance_driven_in_meters,
        nickname: nickname
      }
    else
      %RemoteControlCar{
        battery_percentage: battery_percentage - 1,
        distance_driven_in_meters: distance_driven_in_meters + 20,
        nickname: nickname
      }
    end
  end
end
