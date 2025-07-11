defmodule VehiclesFleetMetricsWeb.PageController do
  use VehiclesFleetMetricsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
