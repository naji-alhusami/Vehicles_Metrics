# defmodule VehiclesFleetMetrics.RandomGenerator do
#   use Ash.Resource,
#     domain: VehiclesFleetMetrics.Api,
#     extensions: [AshGraphql.Resource]

#   resource do
#     require_primary_key?(false)
#   end

#   attributes do
#     attribute :number, :integer do
#       public?(true)
#     end
#   end

#   actions do
#     action :generate_random_numbers, {:array, :struct} do
#       constraints(items: [instance_of: __MODULE__])

#       run(fn _input, _ctx ->
#         numbers =
#           Enum.map(1..5, fn _ ->
#             Ash.Resource.build(__MODULE__, %{number: :rand.uniform(500)})
#           end)

#         {:ok, numbers}
#       end)
#     end
#   end

#   graphql do
#     type(:random_generator)

#     mutations do
#       action(:generate_random_numbers, :generate_random_numbers)
#     end
#   end
# end

defmodule VehiclesFleetMetrics.RandomGenerator do
  use Ash.Resource,
    domain: VehiclesFleetMetrics.Api,
    extensions: [AshGraphql.Resource]

  resource do
    require_primary_key?(false)
  end

  attributes do
    attribute :number, :integer do
      public?(true)
    end
  end

  actions do
    defaults([:read])

    action :generate_random_numbers, {:array, :struct} do
      constraints(items: [instance_of: __MODULE__])

      run(fn _input, _ctx ->
        try do
          numbers =
            1..5
            |> Enum.map(fn _ ->
              %__MODULE__{number: :rand.uniform(500)}
            end)

          {:ok, numbers}
        rescue
          error ->
            IO.inspect(error, label: "🔥 Runtime Error in generate_random_numbers")
            {:error, "Internal server error"}
        end
      end)
    end
  end

  graphql do
    type(:random_generator)

    mutations do
      action(:generate_random_numbers, :generate_random_numbers)
    end
  end
end
