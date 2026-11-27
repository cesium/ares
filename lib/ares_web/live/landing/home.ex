defmodule AresWeb.LandingLive.Home do
  use AresWeb, :landing_view

  alias Ares.{Companies, Event}

  import AresWeb.Components.{
    AsciiBee,
    Companies,
    Gallery,
    LandingSection,
    VenueMap
  }

  @impl true
  def mount(_params, _session, socket) do
    companies = Companies.list_companies()

    {:ok,
     assign(socket,
       sponsors: Enum.filter(companies, &(&1.type == :sponsor)),
       partners: Enum.filter(companies, &(&1.type == :partner)),
       registrations_open: Event.registrations_open?()
     )}
  end
end
