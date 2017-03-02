# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pejs,
  ecto_repos: [Pejs.Repo]

# Configures the endpoint
config :pejs, Pejs.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q6/7wNSkurhVh/Lw7+p5CGxVC7C26tPCHxfsxr9eB4HGmwDEzcCAIs41IjAsmYf4",
  render_errors: [view: Pejs.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pejs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
