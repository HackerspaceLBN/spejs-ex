defmodule Spejs.Web.InteractionsController do
  use Spejs.Web, :controller

  alias Spejs.Api.Interactions

  def devices(conn, %{"data" => data}) do
    try do
      case Spejs.Api.Interactions.update_devices(data) do
        %{errors: errors, updates: updates} ->
          json(conn, %{status: :completed, updates: Enum.count(updates), errors: Enum.count(errors)})
        _ ->
          json(conn, :unknown)
      end
    rescue
      exception ->
        Sentry.capture_exception(exception, [stacktrace: System.stacktrace()])
        json(conn, %{status: :failure, message: exception})
    end
  end

  def at_hackerspace(conn, _params) do
    case Interactions.at_hackerspace |> JSON.encode do
      {:ok, response} -> json(conn, response)
      {:error, message} -> json(conn, message)
    end
  end
end
