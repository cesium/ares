defmodule AresWeb.BackofficeLive.Dashboard do
  use AresWeb, :backoffice_view

  on_mount {AresWeb.UserAuth, :require_authenticated}

  alias Ares.{Accounts, Teams}

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket) do
    if user.is_admin do
      attendees = Accounts.list_attendees()
      teams = Teams.list_teams_with_members()

      {:ok,
       socket
       |> assign(:attendees, attendees)
       |> assign(:teams, teams)
       |> assign(:attendee_count, length(attendees))
       |> assign(:team_count, length(teams))
       |> assign(:paid_teams, Enum.count(teams, &(&1.payment_status == :paid)))
       |> assign(:pending_teams, Enum.count(teams, &(&1.payment_status in [:none, :started])))}
    else
      {:ok,
       socket
       |> redirect(to: ~p"/app/profile")}
    end
  end

  defp format_status(status) do
    status
    |> to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end

  defp payment_badge_class(:paid),
    do:
      "inline-flex items-center rounded-full bg-emerald-500/15 px-3 py-1 text-xs uppercase tracking-widest text-emerald-300"

  defp payment_badge_class(:started),
    do:
      "inline-flex items-center rounded-full bg-amber-500/15 px-3 py-1 text-xs uppercase tracking-widest text-amber-300"

  defp payment_badge_class(:none),
    do:
      "inline-flex items-center rounded-full bg-red-500/15 px-3 py-1 text-xs uppercase tracking-widest text-red-300"

  defp leader_name(team) do
    team.members
    |> Enum.find(fn member -> member.id == team.leader_id end)
    |> case do
      nil -> "Unassigned"
      leader -> leader.name
    end
  end
end
