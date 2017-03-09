defmodule Spejs.Web.Router do
  use Spejs.Web, :router
  use Plug.ErrorHandler
  use Sentry.Plug
  use Coherence.Router         # Add this

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true  # Add this
  end

  pipeline :api do
    plug Corsica, origins: "http://hackerspace-lbn.pl", allow_headers: ["accept", "content-type"]
    plug :accepts, ["json"]
  end

  scope "/", Spejs.Web do
    pipe_through :browser
    coherence_routes :public

    get "/", PageController, :index
  end

  scope "/", Spejs.Web do
    pipe_through :protected
    coherence_routes :protected
    # Add protected routes below

    resources "/users", UserController
    resources "/devices", DeviceController
  end

  # Other scopes may use custom stacks.
  scope "/api", Spejs.Web do
    pipe_through :api
    post "/interactions/devices", InteractionsController, :devices
    get "/at_hackerspace", InteractionsController, :at_hackerspace
  end
end
