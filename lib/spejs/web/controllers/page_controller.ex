defmodule Spejs.Web.PageController do
  use Spejs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
