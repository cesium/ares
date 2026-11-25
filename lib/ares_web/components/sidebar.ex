defmodule AresWeb.Components.Sidebar do
  @moduledoc """
  Backoffice sidebar: static on desktop, a drawer on mobile.
  """
  use Phoenix.Component

  import AresWeb.CoreComponents, only: [icon: 1]

  alias Phoenix.LiveView.JS

  @pages [
    %{title: "Attendees", icon: "hero-user-group", url: "/backoffice/attendees"},
    %{title: "Teams", icon: "hero-users", url: "/backoffice/teams"},
    %{title: "Payments", icon: "hero-credit-card", url: "/backoffice/payments"},
    %{title: "Event Settings", icon: "hero-cog-6-tooth", url: "/backoffice/event_settings"},
    %{title: "Companies", icon: "hero-building-office", url: "/backoffice/companies"},
    %{title: "Schedule", icon: "hero-calendar-days", url: "/backoffice/schedule"}
  ]

  @doc """
  Tracks the current path so the sidebar can highlight the active page.
  Used as `on_mount {AresWeb.Components.Sidebar, :current_path}`.
  """
  def on_mount(:current_path, _params, _session, socket) do
    {:cont,
     Phoenix.LiveView.attach_hook(socket, :current_path, :handle_params, fn _params,
                                                                            url,
                                                                            socket ->
       {:cont, assign(socket, :current_path, URI.parse(url).path)}
     end)}
  end

  @doc """
  Renders the backoffice sidebar and the mobile drawer.
  """
  attr :user, :map, default: nil
  attr :current_path, :string, default: nil

  def sidebar(assigns) do
    assigns = assign(assigns, :pages, @pages)

    ~H"""
    <div
      id="mobile-sidebar-container"
      class="fixed inset-0 z-40 flex lg:hidden"
      aria-modal="true"
      style="display: none;"
    >
      <div
        id="sidebar-overlay"
        class="fixed inset-0 h-full min-h-screen bg-overlay backdrop-blur-sm"
        phx-click={hide_mobile_sidebar()}
      >
      </div>
      <div
        id="mobile-sidebar"
        class="relative flex-1 flex flex-col max-w-xs w-full pt-5 pb-4 bg-background border-r border-line rounded-r-lg h-dvh"
      >
        <button
          type="button"
          class="absolute top-4 right-4 p-2 text-subtle hover:text-foreground transition-colors"
          aria-label="Close navigation"
          phx-click={hide_mobile_sidebar()}
        >
          <.icon name="hero-x-mark" class="size-6" />
        </button>
        <.sidebar_content pages={@pages} current_path={@current_path} user={@user} id="mobile" />
      </div>
    </div>

    <div class="hidden lg:flex lg:shrink-0">
      <div
        id="page-sidebar-desktop"
        class="flex flex-col w-64 pt-5 pb-4 bg-background border-r border-line"
      >
        <.sidebar_content pages={@pages} current_path={@current_path} user={@user} id="desktop" />
      </div>
    </div>
    """
  end

  @doc """
  Renders the mobile top bar with the button that opens the sidebar.
  """
  def sidebar_toggle(assigns) do
    ~H"""
    <div class="flex justify-end lg:hidden px-4 py-2 border-b border-line bg-background">
      <button
        type="button"
        class="p-2 text-foreground"
        aria-label="Open navigation"
        phx-click={show_mobile_sidebar()}
      >
        <.icon name="hero-bars-3" class="size-8" />
      </button>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :pages, :list, required: true
  attr :current_path, :string, default: nil
  attr :user, :map, default: nil

  defp sidebar_content(assigns) do
    ~H"""
    <.link navigate="/" class="flex items-center shrink-0 px-8 pt-4 pb-4">
      <img src="/images/brand/logo-cesium.svg" alt="CeSIUM" class="w-full" />
    </.link>

    <div class="flex flex-col justify-between flex-1 h-0 overflow-y-auto">
      <nav class="px-4 mt-6 space-y-1 font-inter">
        <.link
          :for={page <- @pages}
          navigate={page.url}
          aria-current={active?(page, @current_path) && "page"}
          class={[
            "group flex items-center px-3 py-2 text-sm font-medium rounded-md transition-colors",
            if(active?(page, @current_path),
              do: "bg-surface-hover text-primary",
              else: "text-muted hover:bg-surface hover:text-foreground"
            )
          ]}
        >
          <.icon name={page.icon} class="shrink-0 mr-3 size-6" />
          {page.title}
        </.link>
      </nav>

      <.account_dropdown :if={@user} id={"#{@id}-account"} user={@user} />
    </div>
    """
  end

  attr :id, :string, required: true
  attr :user, :map, required: true

  defp account_dropdown(assigns) do
    ~H"""
    <div class="relative px-3 mt-6 font-inter">
      <button
        id={@id}
        type="button"
        class="w-full rounded-md border border-line px-3.5 py-3 text-left text-sm hover:bg-surface transition-colors"
        phx-click={toggle_dropdown("##{@id}-dropdown")}
        aria-haspopup="true"
      >
        <span class="flex items-center justify-between gap-3 text-subtle">
          <span class="flex items-center gap-3 min-w-0">
            <.icon name="hero-user-circle" class="shrink-0 size-8" />
            <span class="flex flex-col min-w-0">
              <span class="text-foreground font-medium truncate">{@user.name}</span>
              <span class="truncate">{@user.email}</span>
            </span>
          </span>
          <.icon name="hero-chevron-up-down" class="shrink-0 size-5" />
        </span>
      </button>
      <div
        id={"#{@id}-dropdown"}
        phx-click-away={JS.hide(to: "##{@id}-dropdown")}
        class="absolute left-0 right-0 bottom-full z-10 hidden mx-3 mb-1 overflow-hidden rounded-md border border-line bg-surface divide-y divide-line shadow-lg"
        role="menu"
        aria-labelledby={@id}
      >
        <.link
          navigate="/users/settings"
          role="menuitem"
          class="block px-4 py-2 text-sm text-foreground hover:bg-surface-hover"
        >
          Settings
        </.link>
        <.link
          href="/users/log-out"
          method="delete"
          role="menuitem"
          class="block px-4 py-2 text-sm text-foreground hover:bg-surface-hover"
        >
          Log out
        </.link>
      </div>
    </div>
    """
  end

  defp active?(_page, nil), do: false
  defp active?(page, path), do: path == page.url or String.starts_with?(path, page.url <> "/")

  defp toggle_dropdown(to) do
    JS.toggle(
      to: to,
      in: {"transition ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
      out: {"transition ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"}
    )
  end

  defp show_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.show(
      to: "#mobile-sidebar-container",
      display: "flex",
      transition: {"transition fade-in duration-200", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "#mobile-sidebar",
      display: "flex",
      time: 300,
      transition:
        {"transition ease-in-out duration-300 transform", "-translate-x-full", "translate-x-0"}
    )
  end

  defp hide_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.hide(
      to: "#mobile-sidebar-container",
      transition: {"transition fade-out duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "#mobile-sidebar",
      time: 300,
      transition:
        {"transition ease-in-out duration-300 transform", "translate-x-0", "-translate-x-full"}
    )
  end
end
