defmodule AresWeb.Components.Navbar do
  @moduledoc """
  Navigation component with mobile and desktop layouts.
  """
  use Phoenix.Component

  import AresWeb.CoreComponents

  alias Phoenix.LiveView.JS

  alias Ares.Event

  @doc """
  Renders the navigation header with mobile menu support.
  """
  attr :user, :map, default: nil

  def navbar(assigns) do
    ~H"""
    <header
      id="page-header"
      phx-hook="HeaderScroll"
      class="z-60 flex w-full max-w-[1600px] h-24 items-center justify-between page-px py-3 sm:py-4 text-foreground font-inter fixed top-0 left-1/2 -translate-x-1/2 bg-glass backdrop-blur-sm transition-colors duration-300"
    >
      <.link class="flex items-center gap-2 sm:gap-4 hover:text-primary" navigate="/">
        <img src="/images/brand/gub-logo-white.png" alt="BugsByte" class="h-14 w-auto" />
      </.link>
      <div>
        <div class="flex items-center gap-4 sm:gap-6">
          <nav class="hidden sm:block">
            <ul class="flex items-center gap-4 lg:gap-6">
              <!--<li>
                <.link
                  class="hover:text-primary transition-colors"
                  target="_blank"
                  href="/docs/survival-guide.pdf"
                >
                  Survival Guide
                </.link>
              </li> -->
              <li>
                <.link class="hover:text-primary transition-colors" navigate="/faqs">
                  FAQs
                </.link>
              </li>
              <li>
                <.link class="hover:text-primary transition-colors" navigate="/gallery">
                  Gallery
                </.link>
              </li>
              <li>
                <.link
                  class="hover:text-primary transition-colors"
                  navigate={@user && "/app/team-formation"}
                  href="/app/team-formation"
                >
                  Teams
                </.link>
              </li>
              <li>
                <.link
                  class="hover:text-primary transition-colors"
                  target="_blank"
                  href="/docs/regulation.pdf"
                >
                  Regulation
                </.link>
              </li>
              <li>
                <.link
                  class="hover:text-primary transition-colors"
                  href="https://2025.bugsbyte.org/"
                >
                  Previous edition
                </.link>
              </li>
              <li class="relative">
                <%= if @user do %>
                  <button
                    onclick="document.getElementById('profile-menu').classList.toggle('hidden')"
                    class="w-10 h-10 cursor-pointer rounded-full bg-primary flex items-center justify-center text-foreground font-semibold hover:shadow-lg transition-all"
                    title={@user.name}
                  >
                    {String.first(@user.name)}
                  </button>
                  <div
                    id="profile-menu"
                    class={[
                      "hidden absolute right-0 w-48 bg-surface rounded-lg shadow-xl ring-1 ring-line z-50 profile-menu-dropdown"
                    ]}
                  >
                    <.link
                      navigate="/app/profile"
                      class="block px-4 py-2 text-foreground hover:bg-surface-hover rounded-t-lg transition-colors"
                    >
                      View Profile
                    </.link>
                    <%= if @user && @user.is_admin do %>
                      <.link
                        navigate="/backoffice/dashboard"
                        class="block px-4 py-2 text-foreground hover:bg-surface-hover rounded-t-lg transition-colors"
                      >
                        Backoffice
                      </.link>
                    <% end %>
                    <.link
                      navigate="/users/settings"
                      class="block px-4 py-2 text-foreground hover:bg-surface-hover rounded-t-lg transition-colors"
                    >
                      Settings
                    </.link>
                    <.link href="/users/log-out" method="delete" class="border-t border-line">
                      <p class="w-full text-left px-4 py-2 text-foreground hover:bg-surface-hover rounded-b-lg transition-colors cursor-pointer">
                        Log out
                      </p>
                    </.link>
                  </div>
                <% else %>
                  <%= if not Event.registrations_open?() do %>
                    <.button
                      variant="primary"
                      class="btn-sm"
                      href="/log-in"
                      text="Login"
                      icon="hero-arrow-right"
                      icon_position="right"
                    />
                  <% else %>
                    <.button
                      variant="primary"
                      class="btn-sm"
                      href="/register"
                      text="Register"
                      icon="hero-arrow-right"
                      icon_position="right"
                    />
                  <% end %>
                <% end %>
              </li>
            </ul>
          </nav>
          <button
            id="open-nav-button"
            type="button"
            class="sm:hidden text-foreground p-2 rounded hover:bg-opacity-90"
            aria-label="Navigation"
            phx-click={show_mobile_menu()}
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
    </header>

    <div
      id="mobile-menu-container"
      class="fixed inset-0 z-100 flex flex-col sm:hidden"
      aria-modal="true"
      style="display: none;"
    >
      <div
        id="menu-overlay"
        class="fixed inset-0 h-full min-h-screen bg-overlay backdrop-blur-sm"
        phx-click={hide_mobile_menu()}
      >
      </div>
      <div
        id="mobile-menu"
        class="relative w-full h-dvh flex flex-col page-px pt-10 pb-6 text-foreground font-inter bg-overlay backdrop-blur-md rounded-b-lg"
      >
        <header class="flex items-center gap-3 pb-6">
          <.link navigate="/" class="flex items-center">
            <img src="/images/brand/cesium.svg" alt="CeSIUM" class="w-10 h-10" />
          </.link>
          <div class="flex flex-col leading-none">
            <span class="uppercase font-vt323 text-xs text-foreground">hackathon</span>
            <span class="uppercase font-resegrg tracking-wide text-lg">bugsbyte</span>
          </div>
        </header>
        <nav class="font-vt323">
          <ul class="flex flex-col">
            <li>
              <a
                class="block py-2 text-left text-3xl sm:text-4xl font-semibold hover:text-primary transition-colors"
                target="_blank"
                href="/docs/regulation.pdf"
              >
                Regulation
              </a>
            </li>
            <li>
              <a
                class="block py-2 text-left text-3xl sm:text-4xl font-semibold hover:text-primary transition-colors"
                href="/faqs"
              >
                FAQs
              </a>
            </li>
            <li>
              <a
                class="block py-2 text-left text-3xl sm:text-4xl font-semibold hover:text-primary transition-colors"
                href="/gallery"
              >
                Gallery
              </a>
            </li>
            <li>
              <.link
                class="block py-2 text-left text-3xl sm:text-4xl font-semibold hover:text-primary transition-colors"
                href="https://2025.bugsbyte.org/"
              >
                Previous edition
              </.link>
            </li>
            <li>
              <.link
                class="block py-2 text-left text-3xl sm:text-4xl font-semibold hover:text-primary transition-colors"
                navigate={@user && "/app/team-formation"}
                href="/app/team-formation"
              >
                Team formation
              </.link>
            </li>
            <%= if @user && @user.is_admin do %>
              <li>
                <.link
                  navigate="/backoffice/dashboard"
                  class="block py-2 text-left text-3xl sm:text-4xl font-semibold hover:text-primary transition-colors"
                >
                  Dashboard
                </.link>
              </li>
            <% end %>
          </ul>
        </nav>

        <div class="flex-1"></div>

        <div class="flex flex-col items-center gap-3 pb-6">
          <%= if @user do %>
            <.link
              navigate="/app/profile"
              class="flex items-center gap-2 text-muted hover:text-primary transition-colors"
              title={@user.name}
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z"
                />
              </svg>
              Profile
            </.link>
          <% else %>
            <%= if not Event.registrations_open?() do %>
              <.link
                href="/log-in"
                class="flex items-center gap-2 text-muted hover:text-primary transition-colors"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z"
                  />
                </svg>
                Login
              </.link>
            <% else %>
              <.link
                href="/register"
                class="flex items-center gap-2 text-muted hover:text-primary transition-colors"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z"
                  />
                </svg>
                Register
              </.link>
            <% end %>
          <% end %>
          <%= if @user do %>
            <div class="flex items-center gap-4 text-sm text-muted">
              <.link navigate="/users/settings" class="hover:text-primary transition-colors">
                Settings
              </.link>
              <.link
                href="/users/log-out"
                method="delete"
                class="hover:text-primary transition-colors"
              >
                Log out
              </.link>
            </div>
          <% end %>
        </div>

        <div class="flex justify-center pb-4">
          <button
            id="close-nav-button"
            type="button"
            class="w-14 h-14 flex items-center justify-center rounded-none bg-primary text-foreground hover:bg-primary/80 transition-colors"
            aria-label="Close navigation"
            phx-click={hide_mobile_menu()}
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
        </div>
      </div>
    </div>
    """
  end

  defp show_mobile_menu(js \\ %JS{}) do
    js
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.show(
      to: "#mobile-menu-container",
      display: "flex",
      transition: {"transition fade-in duration-200", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "#mobile-menu",
      display: "flex",
      time: 300,
      transition:
        {"transition ease-out duration-300 transform", "-translate-y-full", "translate-y-0"}
    )
  end

  defp hide_mobile_menu(js \\ %JS{}) do
    js
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.hide(
      to: "#mobile-menu-container",
      transition: {"transition fade-out duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "#mobile-menu",
      time: 300,
      transition:
        {"transition ease-in duration-300 transform", "translate-y-0", "-translate-y-full"}
    )
  end
end
