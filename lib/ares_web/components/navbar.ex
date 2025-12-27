defmodule AresWeb.Components.Navbar do
  @moduledoc """
  Navigation component with mobile and desktop layouts.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  @doc """
  Renders the navigation header with mobile menu support.
  """
  attr :user, :map, default: nil

  def navbar(assigns) do
    ~H"""
    <header
      id="page-header"
      class="z-60 flex w-full h-24 items-center justify-between px-4 sm:px-6 md:px-8 py-3 sm:py-4 text-white font-inter fixed top-0 backdrop-blur bg-linear-to-b from-black/90 to-black/30"
    >
      <.link class="flex items-center gap-2 sm:gap-4 hover:text-primary" navigate="/">
        <img src="/images/logo-cesium.svg" alt="Cesium" class="object-fill w-32" />
      </.link>
      <div>
        <div class="flex items-center gap-4 sm:gap-6">
          <nav class="hidden sm:block">
            <ul class="flex items-center gap-4 lg:gap-6">
              <li>
                <.link
                  class="hover:text-primary transition-colors"
                  target="_blank"
                  href="/docs/survival-guide.pdf"
                >
                  Survival Guide
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
                <.link class="hover:text-primary transition-colors" navigate="/faqs">
                  FAQs
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
              <li>
                <.link
                  class="hover:text-primary transition-colors"
                  navigate="/app/team-formation"
                >
                  Teams
                </.link>
              </li>
              <%= if @user && @user.is_admin do %>
                <li>
                  <.link
                    class="hover:text-primary transition-colors text-white"
                    navigate="/app/dashboard"
                  >
                    Dashboard
                  </.link>
                </li>
              <% end %>
              <li class="relative">
                <%= if @user do %>
                  <button
                    onclick="document.getElementById('profile-menu').classList.toggle('hidden')"
                    class="w-10 h-10 cursor-pointer rounded-full bg-primary flex items-center justify-center text-white font-semibold hover:shadow-lg transition-all"
                    title={@user.name}
                  >
                    {String.first(@user.name)}
                  </button>
                  <div
                    id="profile-menu"
                    class={[
                      "hidden absolute right-0 w-48 bg-gray-100 rounded-lg shadow-xl ring-1 ring-gray-800 z-50 profile-menu-dropdown"
                    ]}
                  >
                    <.link
                      navigate="/app/profile"
                      class="block px-4 py-2 text-black hover:bg-gray-300 rounded-t-lg transition-colors"
                    >
                      View Profile
                    </.link>
                    <.link
                      navigate="/users/settings"
                      class="block px-4 py-2 text-black hover:bg-gray-300 rounded-t-lg transition-colors"
                    >
                      Settings
                    </.link>
                    <.link href="/users/log-out" method="delete" class="border-t border-gray-700">
                      <p class="w-full text-left px-4 py-2 text-black hover:bg-gray-300 rounded-b-lg transition-colors cursor-pointer">
                        Log out
                      </p>
                    </.link>
                  </div>
                <% else %>
                  <.link
                    navigate="/register"
                    class="rounded-full px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-white hover:ring-primary hover:text-primary transition-all"
                  >
                    Register
                  </.link>
                <% end %>
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
    </header>

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
          <ul class="flex flex-col space-y-2">
            <li>
              <%= if @user do %>
                <.link
                  navigate="/app/profile"
                  class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                  title={@user.name}
                >
                  Profile
                </.link>
              <% else %>
                <a
                  class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                  href="/register"
                >
                  Register
                </a>
              <% end %>
            </li>
            <%= if @user do %>
              <%= if @user.is_admin do %>
                <li>
                  <.link
                    navigate="/app/dashboard"
                    class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                  >
                    Dashboard
                  </.link>
                </li>
              <% end %>
              <li>
                <.link
                  navigate="/users/settings"
                  class="block w-full py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                >
                  Settings
                </.link>
              </li>
              <li>
                <.link
                  href="/users/log-out"
                  method="delete"
                  class="block w-full py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                >
                  Log out
                </.link>
              </li>
            <% end %>
            <li>
              <.link
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                href="/docs/survival-guide.pdf"
              >
                Survival Guide
              </.link>
            </li>
            <li>
              <a
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                href="images/docs/RegulamentoBugsByte2025.pdf"
              >
                Regulation
              </a>
            </li>
            <li>
              <a
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                href="/faqs"
              >
                FAQs
              </a>
            </li>
            <li>
              <.link
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                href="https://2025.bugsbyte.org/"
              >
                Previous edition
              </.link>
            </li>
            <li>
              <.link
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-primary transition-colors"
                navigate="/app/team-formation"
              >
                Team formation
              </.link>
            </li>
          </ul>
        </nav>
      </div>
    </div>
    """
  end
end
