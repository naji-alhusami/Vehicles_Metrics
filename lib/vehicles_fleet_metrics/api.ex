defmodule VehiclesFleetMetrics.Api do
  # Use Ash.Domain to declare this module as a domain
  use Ash.Domain,
    extensions: [AshGraphql.Domain] # Enables GraphQL for the domain

  resources do 
    resource(VehiclesFleetMetrics.Vehicle)  # The Vehicle resource
    resource(VehiclesFleetMetrics.TelemetryReading) # The TelemetryReading resource
    resource(VehiclesFleetMetrics.RandomGenerator)  # A custom resource for random Vehicle data generation
  end
end
