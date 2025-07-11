# This module defines the Absinthe GraphQL schema for the application
defmodule VehiclesFleetMetricsWeb.Schema do
  # Use Absinthe.Schema to define a GraphQL schema
  use Absinthe.Schema

  # Use AshGraphql to automatically generate Absinthe schema from Ash resources
  use AshGraphql,
    # List of Ash domains to expose in the GraphQL schema
    domains: [VehiclesFleetMetrics.Api],
    # Path where the SDL (schema definition language) file will be written
    generate_sdl_file: "priv/schema.graphql",
    # Automatically generate the SDL file on compilation
    auto_generate_sdl_file?: true

  # Allow queries in AshGraphQL
  query do
  end

  # Allow mutations in AshGraphQL
  mutation do
  end
end
