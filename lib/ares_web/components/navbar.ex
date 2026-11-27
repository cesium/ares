defmodule AresWeb.Components.Navbar do
  @moduledoc """
  Navigation component with mobile and desktop layouts.
  """
  use Phoenix.Component

  import AresWeb.CoreComponents

  alias Ares.Accounts.User
  alias Ares.Event
  alias Phoenix.LiveView.JS

  @doc """
  Renders the navigation dock and the mobile menu.
  """
  attr :user, :map, default: nil

  def navbar(assigns) do
    ~H"""
    <header
      id="page-header"
      phx-hook="HeaderScroll"
      class="z-60 fixed top-4 inset-x-4 lg:inset-x-auto lg:left-1/2 lg:-translate-x-1/2 lg:w-max flex h-14 items-center justify-between gap-4 pixel-corners bg-surface px-2 text-foreground font-jersey10 text-xl"
    >
      <.link
        navigate="/"
        class="flex size-10 shrink-0 items-center justify-center"
        aria-label="BugsByte home"
      >
        <img src="/images/brand/gub-logo-white.png" alt="" class="h-7 w-auto" />
      </.link>

      <nav class="hidden lg:block">
        <ul class="flex items-center whitespace-nowrap">
          <li :for={{label, attrs} <- nav_links(@user)}>
            <.nav_link class="h-10 px-3" {attrs}>{label}</.nav_link>
          </li>
        </ul>
      </nav>

      <div class="relative hidden lg:block">
        <%= if @user do %>
          <button
            onclick="document.getElementById('profile-menu').classList.toggle('hidden')"
            class="size-10 cursor-pointer pixel-corners bg-foreground text-background hover:bg-muted transition-colors"
            title={@user.name}
          >
            {String.first(@user.name)}
          </button>
          <div
            id="profile-menu"
            class="hidden absolute right-0 top-full mt-3 w-48 py-2 pixel-corners bg-surface text-lg z-50"
          >
            <.link navigate="/app/profile" class="block px-4 py-1 text-muted hover:text-foreground">
              View profile
            </.link>
            <.link
              :if={User.admin?(@user)}
              navigate="/backoffice/dashboard"
              class="block px-4 py-1 text-muted hover:text-foreground"
            >
              Backoffice
            </.link>
            <.link navigate="/users/settings" class="block px-4 py-1 text-muted hover:text-foreground">
              Settings
            </.link>
            <.link
              href="/users/log-out"
              method="delete"
              class="block px-4 py-1 text-muted hover:text-foreground"
            >
              Log out
            </.link>
          </div>
        <% else %>
          <.account_button />
        <% end %>
      </div>

      <button
        id="open-nav-button"
        type="button"
        class="lg:hidden flex size-10 items-center justify-center text-muted hover:text-foreground transition-colors"
        aria-label="Open navigation"
        phx-click={show_mobile_menu()}
      >
        <.icon name="hero-bars-3" class="size-6" />
      </button>
    </header>

    <div
      id="mobile-menu-container"
      class="fixed inset-0 z-100 lg:hidden"
      aria-modal="true"
      style="display: none;"
    >
      <div
        id="mobile-menu"
        class="flex h-dvh flex-col gap-10 bg-background p-4 pb-8 text-foreground font-jersey10"
      >
        <div class="flex h-14 shrink-0 items-center justify-between pixel-corners bg-surface px-2">
          <.link
            navigate="/"
            class="flex size-10 items-center justify-center"
            aria-label="BugsByte home"
          >
            <img src="/images/brand/gub-logo-white.png" alt="" class="h-7 w-auto" />
          </.link>
          <button
            id="close-nav-button"
            type="button"
            class="flex size-10 items-center justify-center text-muted hover:text-foreground transition-colors"
            aria-label="Close navigation"
            phx-click={hide_mobile_menu()}
          >
            <.icon name="hero-x-mark" class="size-6" />
          </button>
        </div>

        <nav class="px-2">
          <ul class="flex flex-col gap-1 text-4xl">
            <li :for={{label, attrs} <- nav_links(@user)}>
              <.nav_link class="py-1" {attrs}>{label}</.nav_link>
            </li>
            <li :if={User.admin?(@user)}>
              <.nav_link class="py-1" navigate="/backoffice/dashboard">Backoffice</.nav_link>
            </li>
          </ul>
        </nav>

        <div class="mt-auto flex flex-col gap-4 px-2 text-xl">
          <%= if @user do %>
            <.button navigate="/app/profile" variant="light" text="View profile" class="w-full" />
            <div class="flex gap-6 text-muted">
              <.link navigate="/users/settings" class="hover:text-foreground">Settings</.link>
              <.link href="/users/log-out" method="delete" class="hover:text-foreground">
                Log out
              </.link>
            </div>
          <% else %>
            <.account_button class="w-full" />
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  # Same destinations in the dock and the mobile menu.
  # Teams only makes sense once logged in.
  defp nav_links(user) do
    [
      {"FAQs", [navigate: "/faqs"]},
      {"Gallery", [navigate: "/gallery"]},
      user && {"Teams", [navigate: "/app/team-formation"]},
      {"Regulation", [href: "/docs/regulation.pdf", target: "_blank"]},
      {"Previous edition", [href: "https://2025.bugsbyte.org/"]}
    ]
    |> Enum.filter(& &1)
  end

  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(href navigate target)
  slot :inner_block, required: true

  # The current page gets a green pixel in front, like a cursor.
  defp nav_link(assigns) do
    ~H"""
    <.link
      class={[
        "flex items-center gap-2 text-muted hover:text-foreground current:text-foreground transition-colors",
        "before:hidden before:size-1.5 before:bg-primary current:before:block",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :class, :any, default: nil

  defp account_button(assigns) do
    ~H"""
    <.button
      :if={!Event.registrations_open?()}
      href="/log-in"
      variant="light"
      text="Log in"
      class={["btn-sm", @class]}
    />
    <.button
      :if={Event.registrations_open?()}
      href="/register"
      variant="light"
      text="Register"
      class={["btn-sm", @class]}
    />
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
