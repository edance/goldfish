defmodule Goldfish.Mixfile do
  use Mix.Project

  def project do
    [
      app: :goldfish,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Goldfish.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:ecto_sql, "~> 3.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:comeonin, "~> 4.0"},
      {:argon2_elixir, "~> 1.2"},
      {:guardian, "~> 1.0"},
      {:ex_api_ai, "~> 0.2.2"},
      {:earmark, "~> 1.2.4"},
      {:timex, "~> 3.1"},
      {:jason, "~> 1.0"},
      {:yaml_elixir, "~> 1.3.1"},
      {:tesla, "~> 1.4.3"},
      {:joken, "~> 2.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
