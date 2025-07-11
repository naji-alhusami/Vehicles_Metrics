defmodule VehiclesFleetMetrics.Vehicle do
  # Declare this as an Ash Resource
  use Ash.Resource,
    # Connects this resource to your API domain
    domain: VehiclesFleetMetrics.Api,
    # Uses PostgreSQL as the backend Database
    data_layer: AshPostgres.DataLayer,
    # Enables GraphQL capabilities for this resource
    extensions: [AshGraphql.Resource]

  # PostgreSQL configuration
  postgres do
    table("vehicles")
    repo(VehiclesFleetMetrics.Repo)
  end

  # Attributes (fields) for the Vehicle table
  attributes do
    uuid_primary_key(:id) do
      public?(true)
    end

    attribute :name, :string do
      public?(true)
    end

    attribute :vin, :string do
      public?(true)
    end
  end

  # Relationships with other tables
  relationships do
    has_many :telemetry_readings, VehiclesFleetMetrics.TelemetryReading do
      # Link from Vehicle.id
      source_attribute(:id)
      # To TelemetryReading.vehicle_id
      destination_attribute(:vehicle_id)
    end
  end

  # GraphQL schema
  graphql do
    type(:vehicle)

    queries do
      # Get single vehicle by ID
      get(:get_vehicle, :read)
      # List all vehicles
      list(:list_vehicles, :read)
    end

    mutations do
      # Mutation to create fake vehicles
      action(:generate_fake_vehicles, :generate_fake_vehicles)
    end
  end

  # Resource actions
  actions do
    # Generate basic CRUD actions
    defaults([:read, :create, :update, :destroy])

    # Custom create action named :open
    create :open do
      # Only accept name and vin when creating
      accept([:name, :vin])
    end

    # Custom action to generate fake vehicles
    action :generate_fake_vehicles, {:array, :struct} do
      constraints(items: [instance_of: __MODULE__]) # Returned items are Vehicles
      run(VehiclesFleetMetrics.Generators.VehicleGenerator) # Use external module to run logic
    end
  end
end
