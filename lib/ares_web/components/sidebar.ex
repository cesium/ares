defmodule AresWeb.Components.Sidebar do
  @moduledoc """
  Navigation component with mobile and desktop layouts.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  @doc """
  Renders the navigation header with mobile menu support.
  """
  attr :user, :map, default: nil

  def sidebar(assigns) do
    ~H"""
    <section
      id="page-sidebar"
      class="sm:fixed min-h-24 sm:w-48 flex sm:flex-col sm:h-full items-center gap-2 text-foreground font-inter backdrop-blur bg-glass border-r border-line"
    >
      <.link class="flex items-center gap-2 sm:gap-4 hover:text-primary p-4" navigate="/">
        <img src="/images/brand/logo-cesium.svg" alt="Cesium" class="object-fill min-w-32" />
      </.link>
      <div class="w-full flex">
        <div class="w-full flex gap-4 sm:gap-6 justify-end px-4 sm:px-0">
          <nav class="w-full hidden sm:block">
            <ul class="w-full flex flex-col items-start text-muted">
              <li class="w-full">
                <.link
                  class="block w-full text-left py-3 px-6 hover:bg-surface-hover hover:text-foreground transition-colors duration-150"
                  navigate="/backoffice/dashboard"
                >
                  Dashboard
                </.link>
              </li>
              <li class="w-full">
                <.link
                  class="block w-full text-left py-3 px-6 hover:bg-surface-hover hover:text-foreground transition-colors duration-150 rounded"
                  navigate="/backoffice/event_settings"
                >
                  Event Settings
                </.link>
              </li>
              <li class="w-full">
                <.link
                  class="block w-full text-left py-3 px-6 hover:bg-surface-hover hover:text-foreground transition-colors duration-150 rounded"
                  navigate="/backoffice/companies"
                >
                  Companies
                </.link>
              </li>
            </ul>
          </nav>
          <button
            id="open-nav-button"
            type="button"
            class="sm:hidden text-foreground p-2 rounded hover:bg-opacity-90"
            aria-label="Navigation"
            phx-click={show_mobile_sidebar()}
          >
            <svg class="w-6 h-6 sm:w-8 sm:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h16M4 18h16"
              />
            </svg>
          </button>
        </div>
      </div>
    </section>

    <div
      id="mobile-sidebar-container"
      class="fixed inset-0 z-100 flex sm:hidden"
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
        class="relative flex-1 flex flex-col max-w-xs w-full pt-5 pb-4 text-foreground font-inter backdrop-blur bg-glass border-r border-line rounded-r-lg h-dvh"
      >
        <header class="flex items-center justify-between px-4">
          <.link navigate="/" class="flex items-center py-2">
            <img src="/images/brand/cesium.svg" alt="CeSIUM" class="w-12 h-12" />
          </.link>
          <button
            id="close-nav-button"
            type="button"
            class="text-foreground p-2 rounded hover:bg-opacity-90"
            aria-label="Close navigation"
            phx-click={hide_mobile_sidebar()}
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </button>
        </header>
        <nav class="mt-8">
          <ul class="w-full flex flex-col items-start text-muted">
            <li class="w-full">
              <.link
                class="block w-full text-left py-3 px-6 hover:bg-surface-hover hover:text-foreground transition-colors duration-150"
                navigate="/backoffice/dashboard"
              >
                Dashboard
              </.link>
            </li>
            <li class="w-full">
              <.link
                class="block w-full text-left py-3 px-6 hover:bg-surface-hover hover:text-foreground transition-colors duration-150 rounded"
                navigate="/backoffice/event_settings"
              >
                Event Settings
              </.link>
            </li>
            <li class="w-full">
              <.link
                class="block w-full text-left py-3 px-6 hover:bg-surface-hover hover:text-foreground transition-colors duration-150 rounded"
                navigate="/backoffice/companies"
              >
                Companies
              </.link>
            </li>
          </ul>
        </nav>
      </div>
    </div>
    """
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
