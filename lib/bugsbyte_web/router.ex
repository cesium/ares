defmodule BugsbyteWeb.Router do
  use BugsbyteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BugsbyteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BugsbyteWeb.App do
    pipe_through :browser

    live "/", HomeLive.Index, :index
    live "/faqs", FaqsLive.Index, :index
    live "/register", AccountLive.Index, :new
    live "/team-formation", TeamFormationLive.Index, :index

    live "/teams", TeamsLive.Index, :index
  end

  # Routes handled by top-level controllers (BugsbyteWeb.*)
  scope "/", BugsbyteWeb do
    pipe_through :browser

    post "/register", AccountController, :create
    post "/team-formation", PageController, :create_team
    post "/team-join", PageController, :join_team
  end

  # Other scopes may use custom stacks.
  # scope "/api", BugsbyteWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bugsbyte, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BugsbyteWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
