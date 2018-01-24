defmodule Spejs.Api.Sensors.Storage do
  use GenServer

  # Init
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, :ets.new(:sensor_lookup, [:named_table, :public])}
  end

  def terminate(reason, state) do
    :normal
  end

  def find_sensor(sensor_id) do
    :ets.match(:sensor_lookup, {sensor_id, :"$1"})
  end

  def add_sensor(%{"id" => sensor_id} = sensor_data) do
    :ets.insert(:sensor_lookup, {sensor_id, sensor_data})
  end

  def all_sensors do
    :ets.match(:sensor_lookup, {:"_", :"$1"})
  end
end