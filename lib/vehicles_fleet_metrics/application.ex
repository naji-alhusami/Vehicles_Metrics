defmodule VehiclesFleetMetrics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VehiclesFleetMetricsWeb.Telemetry,
      VehiclesFleetMetrics.Repo,
      {DNSCluster, query: Application.get_env(:vehicles_fleet_metrics, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VehiclesFleetMetrics.PubSub},
      # Start a worker by calling: VehiclesFleetMetrics.Worker.start_link(arg)
      # {VehiclesFleetMetrics.Worker, arg},
      # Start to serve requests, typically the last entry
      VehiclesFleetMetricsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VehiclesFleetMetrics.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VehiclesFleetMetricsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
