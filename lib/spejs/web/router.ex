defmodule Spejs.Web.Router do
  use Spejs.Web, :router
  use Plug.ErrorHandler
  use Sentry.Plug
  use Coherence.Router         # Add this

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session  # Add this
    plug :put_user_token
  end

  pipeline :protected do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true  # Add this
    plug :put_user_token
  end

  pipeline :api do
    plug Corsica, origins: "http://hackerspace-lbn.pl", allow_headers: ["accept", "content-type"]
    plug :accepts, ["json"]
  end

  # Add this block
  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  # Add this block
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", Spejs.Web do
    pipe_through :browser

    get "/", PageController, :index
    # add public resources below
  end

  scope "/", Spejs.Web do
    pipe_through :protected

    # add protected resources below
    resources "/users", UserController
    resources "/devices", DeviceController
  end


  # Other scopes may use custom stacks.
  scope "/api", Spejs.Web do
    pipe_through :api
    post "/interactions/devices", InteractionsController, :devices
    get "/at_hackerspace", InteractionsController, :at_hackerspace
  end

  defp put_user_token(conn, _) do
    case current_user = Coherence.current_user(conn) do
      nil -> conn
      _ ->
        user_token = Phoenix.Token.sign(conn, "user_token", current_user.email)
        conn |> assign(:user_token, user_token)
    end
  end
end
