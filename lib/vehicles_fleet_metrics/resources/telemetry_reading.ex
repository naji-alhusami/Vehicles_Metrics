defmodule VehiclesFleetMetrics.TelemetryReading do
  use Ash.Resource,
    domain: VehiclesFleetMetrics.Api,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  graphql do
    type(:telemetry_reading)

    queries do
      get(:telemetry_reading, :read)
      list(:telemetry_readings, :read)
    end

    mutations do
      create :create_telemetry_reading, :create
      action(:generate_fake_readings, :generate_fake_readings)
    end
  end

  postgres do
    table("telemetry_readings")
    repo(VehiclesFleetMetrics.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    # ID of the vehicle this reading belongs to
    attribute :vehicle_id, :uuid do
      allow_nil?(false)
      public?(true)
    end

    # Distance traveled in kilometers or miles
    attribute :odometer, :float do
      allow_nil?(false)
      public?(true)
    end

    # Percentage of fuel left
    attribute :fuel_level, :float do
      allow_nil?(false)
      public?(true)
    end

    # Speed in km/h or mph
    attribute :speed, :float do
      allow_nil?(true)
      public?(true)
    end

    # Acceleration in m/s^2
    attribute :acceleration, :float do
      allow_nil?(true)
      public?(true)
    end

    # Temperature in °C or °F
    attribute :temperature, :float do
      allow_nil?(true)
      public?(true)
    end

    # System status
    attribute :status, :string do
      allow_nil?(true)
      public?(true)
    end

    # Events like "low_fuel" or "harsh_brake"
    attribute :event, :string do
      allow_nil?(true)
      public?(true)
    end

    # GPS latitude
    attribute :lat, :float do
      allow_nil?(false)
      public?(true)
    end

    # GPS longitude
    attribute :lng, :float do
      allow_nil?(false)
      public?(true)
    end

    # Time this telemetry was recorded
    attribute :recorded_at, :utc_datetime do
      allow_nil?(false)
      public?(true)
    end
  end

  # Define allowed actions  
  actions do
    defaults([ :read])

    create :create do
      accept([
        :vehicle_id,
        :odometer,
        :fuel_level,
        :speed,
        :acceleration,
        :temperature,
        :status,
        :event,
        :lat,
        :lng,
        :recorded_at
      ])
    end

    action :generate_fake_readings, {:array, :struct} do
      constraints(items: [instance_of: __MODULE__])
      run(VehiclesFleetMetrics.Generators.TelemetryReadingGenerator)
    end
  end

  relationships do
    belongs_to :vehicle, VehiclesFleetMetrics.Vehicle do
      source_attribute(:vehicle_id)
      destination_attribute(:id)
    end
  end
end
