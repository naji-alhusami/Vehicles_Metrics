defmodule VehiclesFleetMetrics.Generators.VehicleGenerator do
  @moduledoc "Generates fake vehicles"

  # Declares that this module implements a custom Ash resource action
  use Ash.Resource.Actions.Implementation

  # Vehicle instead of VehiclesFleetMetrics.Vehicle
  alias VehiclesFleetMetrics.Vehicle
  # Api instead of VehiclesFleetMetrics.Api
  alias VehiclesFleetMetrics.Api

  @impl true
  # implementing the Ash.Resource.Actions.Implementation behavior for custom Ash action
  # usin (_) to tell Elixir we are not using those values
  # input: All the input arguments and attributes the action received, References to the resource, actor, and domain.
  # opts: Internal options passed by Ash
  # context: actor / tenant / metadata / tracer 
  def run(_input, _opts, _context) do
    # Generate 5 fake vehicles
    1..5
    |> Enum.map(fn i ->
      # Build a changeset to create a Vehicle with a unique name and VIN
      Ash.Changeset.for_create(
        # The resource to create
        Vehicle,
        # The create action to use (defined in Vehicle resource)
        :open,
        %{
          name: "Vehicle #{i}",
          vin: "VIN#{:crypto.strong_rand_bytes(5) |> Base.encode16()}"
        },
        domain: Api
      )
      # Submit the changeset to create the record
      |> Ash.create()
    end)
    # Accumulate the successful creations into a list or return the first error encountered
    |> Enum.reduce({:ok, []}, fn
      # Add to list if successful
      {:ok, vehicle}, {:ok, acc} -> {:ok, [vehicle | acc]}
      # Stop if any error occurs
      {:error, error}, _ -> {:error, error}
    end)
    # Reverse the list of vehicles to preserve original order
    |> then(fn
      {:ok, vehicles} -> {:ok, Enum.reverse(vehicles)}
      error -> error
    end)
  end
end
