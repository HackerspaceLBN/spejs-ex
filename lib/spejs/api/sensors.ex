defmodule Spejs.Api.Sensors do
  alias Spejs.Api.Sensors.Storage

  def update_sensors(params) do
    params |> Enum.each &Storage.add_sensor/1
  end

  def find_sensor(sensor_id) do
    Storage.find_sensor(sensor_id) |> List.flatten
  end

  def all_sensors do
    Storage.all_sensors |> List.flatten
  end
end