defmodule Spejs.Web.InteractionsController do
  use Spejs.Web, :controller

  alias Spejs.Accounts
  alias Spejs.Api.Interactions

  def devices(conn, %{"data" => data}) do
    json(conn, data)
  end

  def device_join(conn, _params) do
      render "404.html", _params
  end

  def device_leave(conn, _params) do
    render "404.html", _params
  end
end
