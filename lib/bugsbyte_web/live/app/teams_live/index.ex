defmodule BugsbyteWeb.App.TeamsLive.Index do
  use BugsbyteWeb, :app_view

  alias Bugsbyte.Teams

  @impl true
  def mount(_params, _session, socket) do
    teams = Teams.list_teams()
    socket = assign(socket, :teams, teams)
    {:ok, socket}
  end
end
