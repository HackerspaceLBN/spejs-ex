defmodule Spejs.Web.InteractionsController do
  use Spejs.Web, :controller

  alias Spejs.Api.Interactions

  def devices(conn, %{"data" => data}) do
    try do
      case Spejs.Api.Interactions.update_devices(data) do
        :ok -> json(conn, :ok)
        _ -> json(conn, :unknown)
      end
    rescue
      e -> json(conn, %{status: :error, message: e})
    end
  end

  def at_hackerspace(conn, _params) do
    case Interactions.at_hackerspace |> JSON.encode do
      {:ok, response} -> json(conn, response)
      {:error, message} -> json(conn, message)
    end
  end
end
