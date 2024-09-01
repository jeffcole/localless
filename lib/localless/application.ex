defmodule Localless.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LocallessWeb.Telemetry,
      Localless.Repo,
      {DNSCluster, query: Application.get_env(:localless, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Localless.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Localless.Finch},
      # Start a worker by calling: Localless.Worker.start_link(arg)
      # {Localless.Worker, arg},
      # Start to serve requests, typically the last entry
      LocallessWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Localless.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LocallessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
