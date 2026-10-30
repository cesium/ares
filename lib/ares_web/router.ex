defmodule AresWeb.Router do
  use AresWeb, :router

  import AresWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AresWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]

    scope "/api", AresWeb do
      post "/midas/:ares_api_key/webhook", MidasController, :handle_webhook
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AresWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ares, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AresWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", AresWeb do
    pipe_through :browser

    # One live_session so navigation between any pages stays live. Since live
    # navigation skips the plugs, protected LiveViews also enforce
    # authentication in their own on_mount.
    live_session :default,
      on_mount: [{AresWeb.UserAuth, :mount_current_scope}] do
      live "/", LandingLive.Home, :index
      live "/faqs", LandingLive.Faqs, :index
      live "/gallery", LandingLive.Gallery, :index

      live "/register", UserLive.Registration, :new
      live "/log-in", UserLive.Login, :new
      live "/log-in/:token", UserLive.Confirmation, :new

      scope "/" do
        pipe_through :require_authenticated_user

        live "/app/profile", AppLive.Profile, :index
        live "/app/team-formation", AppLive.TeamFormation, :index
        live "/app/team-formation/join", AppLive.TeamFormation, :join
        live "/app/team-formation/code", AppLive.TeamFormation, :code
        live "/app/payment", AppLive.Payment, :index
        live "/app/payment/:id", AppLive.PaymentStatus, :index
        live "/users/settings", UserLive.Settings, :edit
        live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email

        scope "/backoffice", BackofficeLive do
          live "/event_settings", EventSettings, :index
          live "/dashboard", Dashboard, :index
          live "/companies", Companies, :index
          live "/companies/new", Companies, :new
          live "/companies/:id/edit", Companies, :edit
        end
      end
    end

    post "/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete

    scope "/" do
      pipe_through :require_authenticated_user

      post "/users/update-password", UserSessionController, :update_password
    end
  end
end
