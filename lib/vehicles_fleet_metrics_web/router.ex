defmodule VehiclesFleetMetricsWeb.Router do
  use VehiclesFleetMetricsWeb, :router

  # import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VehiclesFleetMetricsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VehiclesFleetMetricsWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # scope "/", VehiclesFleetMetricsWeb do
  #   pipe_through :browser

  #   use AshAdmin.Router

  #   ash_admin("/admin",
  #     apis: [VehiclesFleetMetrics.Api]
  #   )
  # end

  # Other scopes may use custom stacks.
  # scope "/api", VehiclesFleetMetricsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:vehicles_fleet_metrics, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VehiclesFleetMetricsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: VehiclesFleetMetricsWeb.Schema

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: VehiclesFleetMetricsWeb.Schema,
        interface: :simple
    end
  end
end
