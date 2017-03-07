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

  def device_join(conn, _params) do
      render "404.html", _params
  end

  def device_leave(conn, _params) do
    render "404.html", _params
  end
end
