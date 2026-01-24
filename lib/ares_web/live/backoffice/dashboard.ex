defmodule AresWeb.BackofficeLive.Dashboard do
  use AresWeb, :live_view

  alias Ares.{Accounts, Teams}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto font-inter">
      <section class="relative overflow-hidden rounded-3xl border border-white/10 bg-gradient-to-br from-gray-900 via-black to-gray-900 p-8 sm:p-10 mb-10">
        <div class="absolute -top-24 -right-20 h-64 w-64 rounded-full bg-primary/20 blur-3xl"></div>
        <div class="absolute -bottom-24 -left-16 h-72 w-72 rounded-full bg-pink-500/10 blur-3xl">
        </div>
        <div class="relative">
          <p class="text-xs uppercase tracking-[0.4em] text-gray-400">Operations</p>
          <h1 class="text-4xl sm:text-5xl font-resegrg mt-3">BUGSBYTE 2026</h1>
        </div>

        <div class="relative mt-8 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
            <p class="text-xs uppercase tracking-widest text-gray-400">Attendees</p>
            <p class="text-3xl font-vt323 text-white mt-2">{@attendee_count}</p>
          </div>
          <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
            <p class="text-xs uppercase tracking-widest text-gray-400">Teams</p>
            <p class="text-3xl font-vt323 text-white mt-2">{@team_count}</p>
          </div>
          <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
            <p class="text-xs uppercase tracking-widest text-gray-400">Paid</p>
            <p class="text-3xl font-vt323 text-emerald-300 mt-2">{@paid_teams}</p>
          </div>
          <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
            <p class="text-xs uppercase tracking-widest text-gray-400">Pending</p>
            <p class="text-3xl font-vt323 text-amber-300 mt-2">{@pending_teams}</p>
          </div>
        </div>
      </section>

      <section class="grid grid-cols-1 xl:grid-cols-2 gap-8">
        <div class="rounded-3xl border border-gray-800 bg-gray-950/70 p-6">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-3xl font-resegrg">Attendees</h2>
              <p class="text-sm text-gray-400">All registered participants.</p>
            </div>
            <span class="text-xs uppercase tracking-[0.3em] text-gray-500">
              {length(@attendees)} total
            </span>
          </div>

          <div class="overflow-x-auto">
            <table class="min-w-full text-left text-sm">
              <thead class="text-xs uppercase tracking-widest text-gray-500 border-b border-gray-800">
                <tr>
                  <th class="py-3 pr-4">Name</th>
                  <th class="py-3 pr-4">Email</th>
                  <th class="py-3 pr-4">Phone</th>
                  <th class="py-3 pr-4">University</th>
                  <th class="py-3 pr-4">Team</th>
                  <th class="py-3">Payment</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-900 text-gray-200">
                <%= for attendee <- @attendees do %>
                  <tr class="hover:bg-white/5">
                    <td class="py-3 pr-4 font-semibold">{attendee.name}</td>
                    <td class="py-3 pr-4 text-gray-400">{attendee.email}</td>
                    <td class="py-3 pr-4 text-gray-400">{attendee.phone || "-"}</td>
                    <td class="py-3 pr-4">{attendee.university || "-"}</td>
                    <td class="py-3 pr-4">
                      <%= if attendee.team do %>
                        <div class="font-medium">{attendee.team.name}</div>
                        <div class="text-xs text-gray-500 uppercase tracking-widest">
                          {attendee.team.code}
                        </div>
                      <% else %>
                        <span class="text-gray-500">No team</span>
                      <% end %>
                    </td>
                    <td class="py-3">
                      <%= if attendee.team do %>
                        <span class={payment_badge_class(attendee.team.payment_status)}>
                          {format_status(attendee.team.payment_status)}
                        </span>
                      <% else %>
                        <span class="text-xs uppercase tracking-widest text-gray-500">
                          N/A
                        </span>
                      <% end %>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>

        <div class="rounded-3xl border border-gray-800 bg-gray-950/70 p-6">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-3xl font-resegrg">Teams</h2>
              <p class="text-sm text-gray-400">Payment progress and membership.</p>
            </div>
            <span class="text-xs uppercase tracking-[0.3em] text-gray-500">
              {length(@teams)} total
            </span>
          </div>

          <div class="overflow-x-auto">
            <table class="min-w-full text-left text-sm">
              <thead class="text-xs uppercase tracking-widest text-gray-500 border-b border-gray-800">
                <tr>
                  <th class="py-3 pr-4">Team</th>
                  <th class="py-3 pr-4">Leader</th>
                  <th class="py-3 pr-4">Members</th>
                  <th class="py-3 pr-4">Code</th>
                  <th class="py-3">Payment</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-900 text-gray-200">
                <%= for team <- @teams do %>
                  <tr class="hover:bg-white/5">
                    <td class="py-3 pr-4 font-semibold">{team.name}</td>
                    <td class="py-3 pr-4 text-gray-400">{leader_name(team)}</td>
                    <td class="py-3 pr-4">
                      <span class="font-medium">{length(team.members)}</span>/5
                    </td>
                    <td class="py-3 pr-4 text-gray-400 uppercase tracking-widest text-xs">
                      {team.code}
                    </td>
                    <td class="py-3">
                      <span class={payment_badge_class(team.payment_status)}>
                        {format_status(team.payment_status)}
                      </span>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      </section>
    </div>
    """
  end

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
      "inline-flex items-center rounded-full bg-rose-500/15 px-3 py-1 text-xs uppercase tracking-widest text-rose-300"

  defp leader_name(team) do
    team.members
    |> Enum.find(fn member -> member.id == team.leader_id end)
    |> case do
      nil -> "Unassigned"
      leader -> leader.name
    end
  end
end
