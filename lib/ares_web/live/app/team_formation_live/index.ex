defmodule AresWeb.App.TeamFormationLive.Index do
  use AresWeb, :app_view

  alias Ares.Teams

  @impl true
  def mount(params, _session, socket) do
    changeset = Teams.change_team(%Teams.Team{})
    tab = Map.get(params, "tab", "create")

    socket =
      socket
      |> assign(:changeset, changeset)
      |> assign(:tab, tab)

    {:ok, socket}
  end
end
