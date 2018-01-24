defmodule SpejsWeb.Api.SensorsController do
  use SpejsWeb, :controller

  alias Spejs.Api.Sensors

  def update(conn, %{"sensors" => params}) do
    try do

    rescue
      exception ->
        Sentry.capture_exception(exception, [stacktrace: System.stacktrace()])
        json(conn, %{status: :failure, message: exception})
    end
    json(conn, Sensors.update_sensors(params))
  end

  def find_sensor(conn, %{"sensor_id" => sensor_id}) do
    with {:ok, sensor} <-Sensors.find_sensor(sensor_id)
    do
      json(conn, sensor)
    else
      err -> json(conn, err)
    end
  end

  def all_sensors(conn, _) do
    json(conn, Sensors.all_sensors)
  end
end