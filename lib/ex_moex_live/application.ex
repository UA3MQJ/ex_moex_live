defmodule ExMoexLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExMoexLiveWeb.Telemetry,
      ExMoexLive.Repo,
      {DNSCluster, query: Application.get_env(:ex_moex_live, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ExMoexLive.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ExMoexLive.Finch},
      # Start a worker by calling: ExMoexLive.Worker.start_link(arg)
      # {ExMoexLive.Worker, arg},
      # Start to serve requests, typically the last entry
      ExMoexLiveWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExMoexLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExMoexLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
