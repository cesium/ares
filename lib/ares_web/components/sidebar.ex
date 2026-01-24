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
      class="sm:fixed min-h-24 sm:w-48 flex sm:flex-col sm:h-full items-center gap-2 text-white font-inter backdrop-blur bg-linear-to-b from-black/90 to-black/30 border-r border-zinc-900"
    >
      <.link class="flex items-center gap-2 sm:gap-4 hover:text-primary p-4" navigate="/">
        <img src="/images/logo-cesium.svg" alt="Cesium" class="object-fill min-w-32" />
      </.link>
      <div class="w-full flex">
        <div class="w-full flex gap-4 sm:gap-6 justify-end px-4 sm:px-0">
          <nav class="w-full hidden sm:block">
            <ul class="w-full flex flex-col items-start text-zinc-400">
              <li class="w-full">
                <.link
                  class="block w-full text-left py-3 px-6 hover:bg-white/10 hover:text-white transition-colors duration-150"
                  navigate="/backoffice/dashboard"
                >
                  Dashboard
                </.link>
              </li>
              <li class="w-full">
                <.link
                  class="block w-full text-left py-3 px-6 hover:bg-white/10 hover:text-white transition-colors duration-150 rounded"
                  navigate="/backoffice/event_settings"
                >
                  Event Settings
                </.link>
              </li>
            </ul>
          </nav>
          <button
            id="open-nav-button"
            type="button"
            class="sm:hidden text-white p-2 rounded hover:bg-opacity-90"
            aria-label="Navigation"
            phx-click={
              JS.toggle(to: "#menu-modal")
              |> JS.add_class("overflow-hidden", to: "body")
            }
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
      id="menu-modal"
      class="hidden fixed inset-0 bg-black px-4 sm:px-8 py-4 text-white z-100 font-inter"
    >
      <div class="space-y-4 w-full h-full" role="dialog" aria-modal="true">
        <header class="text-right">
          <button
            id="close-nav-button"
            type="button"
            class="text-white p-2 rounded hover:bg-opacity-90"
            aria-label="Close navigation"
            phx-click={JS.toggle(to: "#menu-modal") |> JS.remove_class("overflow-hidden", to: "body")}
          >
            <svg
              class="w-6 h-6 sm:w-8 sm:h-8"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </button>
        </header>
        <.link navigate="/" class="flex justify-center py-4">
          <img src="/images/cesium.svg" alt="CeSIUM" class="w-14 h-14 sm:w-16 sm:h-16" />
        </.link>
        <nav>
          <ul class="w-full flex flex-col sm:items-start text-zinc-400">
            <li class="w-full">
              <.link
                class="block w-full text-left py-3 px-6 hover:bg-white/10 hover:text-white transition-colors duration-150"
                navigate="/backoffice/dashboard"
              >
                Dashboard
              </.link>
            </li>
            <li class="w-full">
              <.link
                class="block w-full text-left py-3 px-6 hover:bg-white/10 hover:text-white transition-colors duration-150 rounded"
                navigate="/backoffice/event_settings"
              >
                Event Settings
              </.link>
            </li>
          </ul>
        </nav>
      </div>
    </div>
    """
  end
end
