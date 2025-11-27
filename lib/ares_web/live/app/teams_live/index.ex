defmodule AresWeb.App.TeamsLive.Index do
  use AresWeb, :app_view

  alias Ares.Teams

  @impl true
  def mount(_params, _session, socket) do
    teams = Teams.list_teams()
    socket = assign(socket, :teams, teams)
    {:ok, socket}
  end
end
