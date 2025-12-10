defmodule AresWeb.App.TeamFormationLive.Index do
  use AresWeb, :app_view

  alias Ares.Teams
  alias Ares.Users

  @impl true
  def mount(params, session, socket) do
    changeset = Teams.change_team(%Teams.Team{})
    tab = Map.get(params, "tab", "create")
    user_id = session["user_id"]

    user =
      case user_id && Users.get_user(user_id) do
        {:ok, u} -> u
        _ -> nil
      end

    # If user already has a team, redirect to teams page
    if user && user.team_code do
      {:ok,
       socket
       |> put_flash(:info, "You are already in a team!")
       |> redirect(to: "/teams")}
    else
      # Load teams that are looking for members
      available_teams = Teams.list_teams() |> Enum.filter(& &1.looking_for_members)

      socket =
        socket
        |> assign(:changeset, changeset)
        |> assign(:tab, tab)
        |> assign(:user, user)
        |> assign(:available_teams, available_teams)

      {:ok, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    tab = Map.get(params, "tab", "create")

    socket
    |> assign(:tab, tab)
    |> assign(:page_title, "Team Formation")
  end

  defp apply_action(socket, :join, params) do
    tab = Map.get(params, "tab", "join")

    socket
    |> assign(:tab, tab)
    |> assign(:page_title, "Join Team")
  end

  @impl true
  def handle_event("open_join_modal", %{"team_code" => team_code}, socket) do
    {:noreply,
     socket
     |> assign(:selected_team_code, team_code)
     |> push_patch(to: ~p"/team-formation/join?#{[tab: socket.assigns.tab]}")}
  end

  @impl true
  def handle_event("join_team", %{"team_code" => entered_code}, socket) do
    user = socket.assigns.user
    expected_code = socket.assigns.selected_team_code

    cond do
      !user ->
        {:noreply,
         socket
         |> put_flash(:error, "You must be logged in to join a team.")
         |> push_navigate(to: "/register")}

      is_nil(expected_code) or entered_code != expected_code ->
        {:noreply,
         socket
         |> put_flash(:error, "Team code does not match. Please enter the correct code.")
         |> assign(:selected_team_code, expected_code)}

      true ->
        process_team_join(socket, user, entered_code)
    end
  end

  defp process_team_join(socket, user, team_code) do
    case Teams.get_team_by_code(team_code) do
      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "Unable to join team. Please check the team code and try again.")
         |> push_patch(to: ~p"/team-formation?#{[tab: socket.assigns.tab]}")}

      team ->
        validate_and_join_team(socket, user, team, team_code)
    end
  end

  defp validate_and_join_team(socket, user, team, team_code) do
    cond do
      not team.looking_for_members ->
        {:noreply,
         socket
         |> put_flash(:error, "This team is not currently accepting new members.")
         |> push_patch(to: ~p"/team-formation?#{[tab: socket.assigns.tab]}")}

      length(team.members || []) >= 5 ->
        {:noreply,
         socket
         |> put_flash(:error, "The team is full, you cannot open it")
         |> push_patch(to: ~p"/team-formation?#{[tab: socket.assigns.tab]}")}

      true ->
        join_team(socket, user, team, team_code)
    end
  end

  defp join_team(socket, user, team, team_code) do
    case Users.update_user(user, %{"team_code" => team_code}) do
      {:ok, _updated_user} ->
        member_count = length(team.members || [])
        new_member_count = member_count + 1

        if new_member_count >= 5 do
          Teams.close_team(team)
        end

        {:noreply,
         socket
         |> put_flash(:info, "Successfully joined the team!")
         |> push_navigate(to: "/teams")}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Unable to join team. Please try again.")
         |> push_patch(to: ~p"/team-formation?#{[tab: socket.assigns.tab]}")}
    end
  end
end
