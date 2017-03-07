defmodule Spejs.Web.InteractionsController do
  use Spejs.Web, :controller

  alias Spejs.Accounts
  alias Spejs.Api.Interactions

  def devices(conn, %{"data" => data}) do
    case Spejs.Api.Interactions.update_devices(data) do
      {:error, message} -> json(conn, message)
      {status, _} -> json(conn, status)
    end
  end

  def at_hackerspace(conn, _params) do
    case Interactions.at_hackerspace |> JSON.encode do
      {:ok, response} -> json(conn, response)
      {:error, message} -> json(conn, message)
    end
  end
end
