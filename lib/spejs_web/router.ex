defmodule SpejsWeb.Router do
  use SpejsWeb, :router
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
    plug Corsica, origins: "*", allow_headers: ["accept", "content-type"]
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

  scope "/", SpejsWeb do
    pipe_through :browser

    get "/", PageController, :index
    # add public resources below
  end

  scope "/", SpejsWeb do
    pipe_through :protected

    # add protected resources below
    resources "/users", UserController
    resources "/devices", DeviceController
    resources "/networks", NetworkController
    resources "/phone_calls", PhoneCallController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  scope "/api", SpejsWeb do
    pipe_through :api
    get "/", InteractionsController, :index
    post "/interactions/devices", InteractionsController, :devices
    post "/interactions/sensors", InteractionsController, :sensors
    post "/interactions/clear_devices", InteractionsController, :clear_devices
    get "/at_hackerspace", InteractionsController, :at_hackerspace

    scope "/telecom" do
      get "/", TelecomController, :index
      post "/start_call", TelecomController, :start_call
      post "/end_call", TelecomController, :end_call

      # Temporary GET requests

      get "/start_call", TelecomController, :start_call
      get "/end_call", TelecomController, :end_call
      get "/status", TelecomController, :status
    end
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
