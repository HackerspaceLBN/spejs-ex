defmodule Spejs.Mixfile do
  use Mix.Project

  def project do
    [app: :spejs,
     version: "0.0.1",
     revision: revision(),
     branch: branch(),
     elixir: "~> 1.6.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Spejs.Application, []},
      extra_applications: [:corsica, :logger],
      env: [revision: "#{branch()}-#{revision()}"] ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "web"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},

      {:corsica, "~> 1.0"},
      {:sentry, "~> 6.0.4"},
      {:json, "~> 1.0"},
      {:coherence, "~> 0.5"},
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.setup", "test"]]
  end

  defp revision do
    {result, _exit_code} = System.cmd("git", ["rev-parse", "HEAD"])
    String.slice(result, 0, 7)
  end

  defp branch do
    {result, _exit_code} = System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"])
    result
  end
end
