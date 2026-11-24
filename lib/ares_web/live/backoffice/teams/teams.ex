defmodule AresWeb.BackofficeLive.Teams do
  use AresWeb, :backoffice_view

  alias Ares.Teams

  @impl true
  def mount(_params, _session, socket) do
    teams = Teams.list_teams_with_members()

    {:ok,
     socket
     |> assign(:page_title, "Teams")
     |> assign(:teams, teams)
     |> assign(:paid, Enum.count(teams, &(&1.payment_status == :paid)))}
  end

  defp leader_name(team) do
    case Enum.find(team.members, &(&1.id == team.leader_id)) do
      nil -> "Unassigned"
      leader -> leader.name
    end
  end
end
