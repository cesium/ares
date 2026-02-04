defmodule AresWeb.LandingLive.Home do
  use AresWeb, :live_view

  alias Ares.Companies
  import AresWeb.Components.{Companies, SquigglyEffect}

  @impl true
  def mount(_params, _session, socket) do
    companies = Companies.list_companies()
    sponsors = Enum.filter(companies, fn c -> c.type == :sponsor end)
    partners = Enum.filter(companies, fn c -> c.type == :partner end)

    socket =
      socket
      |> assign(:sponsors, sponsors)
      |> assign(:partners, partners)
      |> assign(:supporters, [])
      |> assign(:gallery_images, [])
      |> assign(:user, nil)

    {:ok, socket}
  end
end
