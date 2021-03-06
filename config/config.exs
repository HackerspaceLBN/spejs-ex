# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :spejs,
  ecto_repos: [Spejs.Repo]

# Configures the endpoint
config :spejs, SpejsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q6/7wNSkurhVh/Lw7+p5CGxVC7C26tPCHxfsxr9eB4HGmwDEzcCAIs41IjAsmYf4",
  render_errors: [view: SpejsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Spejs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: Mix.env,
  included_environments: [:prod]

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Spejs.Accounts.User,
  repo: Spejs.Repo,
  module: SpejsWeb,
  logged_out_url: "/",
  opts: [:authenticatable]
# %% End Coherence Configuration %%

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Spejs.Accounts.User,
  repo: Spejs.Repo,
  module: Spejs,
  web_module: SpejsWeb,
  router: SpejsWeb.Router,
  messages_backend: SpejsWeb.Coherence.Messages,
  logged_out_url: "/",
  opts: [:authenticatable]
# %% End Coherence Configuration %%
