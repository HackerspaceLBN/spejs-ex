defmodule SpejsWeb.PageController do
  use SpejsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
