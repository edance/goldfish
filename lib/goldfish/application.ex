defmodule Goldfish.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Goldfish.Repo, []),
      # Start the endpoint when the application starts
      supervisor(GoldfishWeb.Endpoint, []),
      # Start the presence
      supervisor(GoldfishWeb.Presence, []),
      # Start your own worker by calling: Goldfish.Worker.start_link(arg1, arg2, arg3)
      supervisor(Goldfish.Chatbot.AccessToken, []),
      # worker(Goldfish.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Goldfish.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GoldfishWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
