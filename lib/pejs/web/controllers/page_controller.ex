defmodule Pejs.Web.PageController do
  use Pejs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
