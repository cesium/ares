defmodule BugsbyteWeb.App.TeamsLive.Index do
  use BugsbyteWeb, :app_view

  alias Bugsbyte.Teams
  alias Bugsbyte.Users

  @impl true
  def mount(_params, session, socket) do
    teams = Teams.list_teams()
    user_id = session["user_id"]
    user = if user_id, do: Users.get_user!(user_id), else: nil

    # Find user's team if they have a team_code
    user_team = if user && user.team_code, do: Teams.get_team_by_code(user.team_code), else: nil

    socket =
      socket
      |> assign(:teams, teams)
      |> assign(:user, user)
      |> assign(:user_team, user_team)

    {:ok, socket}
  end
end
