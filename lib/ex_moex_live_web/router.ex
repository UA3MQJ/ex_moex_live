defmodule ExMoexLiveWeb.Router do
  use ExMoexLiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExMoexLiveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExMoexLiveWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/boards", BoardLive.Index, :index
    live "/boards/new", BoardLive.Index, :new
    live "/boards/:id/edit", BoardLive.Index, :edit

    live "/boards/:id", BoardLive.Show, :show
    live "/boards/:id/show/edit", BoardLive.Show, :edit

    live "/board_groups", BoardGroupLive.Index, :index
    live "/board_groups/new", BoardGroupLive.Index, :new
    live "/board_groups/:id/edit", BoardGroupLive.Index, :edit

    live "/board_groups/:id", BoardGroupLive.Show, :show
    live "/board_groups/:id/show/edit", BoardGroupLive.Show, :edit

    live "/durations", DurationLive.Index, :index
    live "/durations/new", DurationLive.Index, :new
    live "/durations/:id/edit", DurationLive.Index, :edit

    # live "/durations/:id", DurationLive.Show, :show
    # live "/durations/:id/show/edit", DurationLive.Show, :edit

    live "/engines", EngineLive.Index, :index
    live "/engines/new", EngineLive.Index, :new
    live "/engines/:id/edit", EngineLive.Index, :edit

    live "/engines/:id", EngineLive.Show, :show
    live "/engines/:id/show/edit", EngineLive.Show, :edit

    live "/markets", MarketLive.Index, :index
    live "/markets/new", MarketLive.Index, :new
    live "/markets/:id/edit", MarketLive.Index, :edit

    live "/markets/:id", MarketLive.Show, :show
    live "/markets/:id/show/edit", MarketLive.Show, :edit

    live "/security_collections", SecurityCollectionLive.Index, :index
    live "/security_collections/new", SecurityCollectionLive.Index, :new
    live "/security_collections/:id/edit", SecurityCollectionLive.Index, :edit

    live "/security_collections/:id", SecurityCollectionLive.Show, :show
    live "/security_collections/:id/show/edit", SecurityCollectionLive.Show, :edit

    live "/security_groups", SecurityGroupLive.Index, :index
    live "/security_groups/new", SecurityGroupLive.Index, :new
    live "/security_groups/:id/edit", SecurityGroupLive.Index, :edit

    live "/security_groups/:id", SecurityGroupLive.Show, :show
    live "/security_groups/:id/show/edit", SecurityGroupLive.Show, :edit

    live "/security_types", SecurityTypeLive.Index, :index
    live "/security_types/new", SecurityTypeLive.Index, :new
    live "/security_types/:id/edit", SecurityTypeLive.Index, :edit

    live "/security_types/:id", SecurityTypeLive.Show, :show
    live "/security_types/:id/show/edit", SecurityTypeLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExMoexLiveWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ex_moex_live, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExMoexLiveWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
