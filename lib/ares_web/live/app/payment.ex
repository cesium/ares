defmodule AresWeb.AppLive.Payment do
  use AresWeb, :live_view

  alias Ares.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}></Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    team =
      if user.team_id do
        Teams.get_team!(user.team_id)
      else
        nil
      end

    {:ok, assign(socket, user: Map.put(user, :team, team))}
  end
end
