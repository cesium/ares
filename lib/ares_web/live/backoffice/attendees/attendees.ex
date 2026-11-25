defmodule AresWeb.BackofficeLive.Attendees do
  use AresWeb, :backoffice_view

  alias Ares.Accounts

  @impl true
  def mount(_params, _session, socket) do
    attendees = Accounts.list_attendees()

    {:ok,
     socket
     |> assign(:page_title, "Attendees")
     |> assign(:attendees, attendees)
     |> assign(:with_team, Enum.count(attendees, & &1.team))}
  end
end
