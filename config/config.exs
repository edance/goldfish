# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :goldfish,
  ecto_repos: [Goldfish.Repo]

config :phoenix, :json_library, Jason

# Configures the endpoint
config :goldfish, GoldfishWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DyAhNL5vyAWVsThb9W4mjxrhzMgfe3ESl+NfvVKl0QphojGtjPPdQJKFsJAH2twz",
  render_errors: [view: GoldfishWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Goldfish.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :goldfish, Goldfish.Guardian,
  issuer: "goldfish",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :slack, api_token: System.get_env("SLACK_TOKEN")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
