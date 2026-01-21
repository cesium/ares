defmodule AresWeb.LandingLive.Home do
  use AresWeb, :live_view

  alias Ares.Companies
  import AresWeb.Components.{Companies, SquigglyEffect}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:companies, Companies.list_companies())
      |> assign(:supporters, [])
      |> assign(:gallery_images, [])
      |> assign(:user, nil)

    {:ok, socket}
  end
end
