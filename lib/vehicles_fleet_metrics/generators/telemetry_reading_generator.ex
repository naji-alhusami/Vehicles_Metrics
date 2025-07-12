defmodule VehiclesFleetMetrics.Generators.TelemetryReadingGenerator do
  @moduledoc "Generates fake telemetry readings for all vehicles"

  use Ash.Resource.Actions.Implementation

  alias VehiclesFleetMetrics.TelemetryReading
  alias VehiclesFleetMetrics.Vehicle
  alias VehiclesFleetMetrics.Api

  @impl true
  def run(_input, _opts, _context) do
    with {:ok, vehicles} <- Ash.read(Vehicle, domain: Api) do
      vehicles
      |> Enum.flat_map(fn vehicle ->
        1..10
        |> Enum.map(fn _ ->
          generate_random_reading(vehicle.id)
        end)
      end)
      |> Enum.reduce({:ok, []}, fn
        {:ok, reading}, {:ok, acc} -> {:ok, [reading | acc]}
        {:error, error}, _ -> {:error, error}
      end)
      |> then(fn
        {:ok, readings} -> {:ok, Enum.reverse(readings)}
        error -> error
      end)
    end
  end

  defp generate_random_reading(vehicle_id) do
    attrs = %{
      vehicle_id: vehicle_id,
      odometer: :rand.uniform() * 100_000,
      fuel_level: :rand.uniform() * 100,
      speed: :rand.uniform() * 120,
      acceleration: :rand.uniform() * 10,
      temperature: 20.0 + :rand.uniform() * 15.0,
      status: Enum.random(["ok", "warning", "error"]),
      event: Enum.random(["", "low_fuel", "harsh_brake", "engine_check"]),
      lat: random_in_range(34.0, 36.0),
      lng: random_in_range(-118.0, -117.0),
      recorded_at: DateTime.utc_now()
    }

    Ash.Changeset.for_create(
      TelemetryReading,
      :create,
      attrs,
      domain: Api
    )
    |> Ash.create()
  end

  defp random_in_range(min, max) do
    min + :rand.uniform() * (max - min)
  end
end
