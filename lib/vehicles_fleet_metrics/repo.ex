# defmodule VehiclesFleetMetrics.Repo do
#   use Ecto.Repo,
#     otp_app: :vehicles_fleet_metrics,
#     adapter: Ecto.Adapters.Postgres
# end

# defmodule VehiclesFleetMetrics.Repo do
#   use AshPostgres.Repo, otp_app: :vehicles_fleet_metrics

#   def installed_extensions do
#     ["uuid-ossp"]
#   end

#   def min_pg_version do
#     Version.parse!("17.5.0")
#   end
# end

defmodule VehiclesFleetMetrics.Repo do
  use AshPostgres.Repo,
    otp_app: :vehicles_fleet_metrics,
    warn_on_missing_ash_functions?: false

  def installed_extensions do
    ["uuid-ossp"]
  end

  def min_pg_version do
    Version.parse!("17.5.0")
  end
end
