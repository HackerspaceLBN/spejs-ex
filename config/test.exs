use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :spejs, Spejs.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :spejs, Spejs.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  database: "spejs_test",
  hostname: System.get_env("PGHOST"),
  pool: Ecto.Adapters.SQL.Sandbox

config :sentry,
  tags: %{
    env: "testing"
  }
