defmodule Spejs.Web.Router do
  use Spejs.Web, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Corsica, origins: "http://hackerspace-lbn.pl", allow_headers: ["accept", "content-type"]
    plug :accepts, ["json"]
  end

  scope "/", Spejs.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/devices", DeviceController
  end

  # Other scopes may use custom stacks.
  scope "/api", Spejs.Web do
    pipe_through :api
    post "/interactions/devices", InteractionsController, :devices
  end
end
