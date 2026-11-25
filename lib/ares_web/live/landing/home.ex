defmodule AresWeb.LandingLive.Home do
  use AresWeb, :landing_view

  alias Ares.Companies
  import AresWeb.Components.{Companies, Gallery, SquigglyEffect, LandingSection, VenueMap}

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
      |> assign(:user, nil)

    {:ok, socket}
  end
end
