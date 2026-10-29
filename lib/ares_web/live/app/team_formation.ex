defmodule AresWeb.AppLive.TeamFormation do
  use AresWeb, :app_view

  on_mount {AresWeb.UserAuth, :require_authenticated}

  import AresWeb.Components.Page

  alias Ares.Teams

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: %{is_admin: true}}}} = socket) do
    {:ok,
     socket
     |> put_flash(:error, "Admins cannot join teams.")
     |> redirect(to: ~p"/app/profile")}
  end

  @impl true
  def mount(
        _params,
        _session,
        %{assigns: %{current_scope: %{user: %{team_id: team_id}}}} = socket
      )
      when not is_nil(team_id) do
    {:ok,
     socket
     |> put_flash(:error, "You are already in a team.")
     |> redirect(to: ~p"/app/profile")}
  end

  @impl true
  def mount(params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    tab = Map.get(params, "tab", "create")
    available_teams = Teams.list_available_teams()

    {:ok,
     socket
     |> assign(user: user, tab: tab)
     |> assign(available_teams: available_teams)
     |> assign_form(Teams.change_team(%Teams.Team{}, %{}))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    tab = Map.get(params, "tab", "create")

    socket
    |> assign(:tab, tab)
  end

  defp apply_action(socket, :join, params) do
    tab = Map.get(params, "tab", "join")

    case Enum.find(socket.assigns.available_teams, &(&1.id == params["team"])) do
      nil ->
        socket
        |> put_flash(:error, "This team is no longer available.")
        |> push_patch(to: ~p"/app/team-formation?#{[tab: tab]}")

      team ->
        socket
        |> assign(:tab, tab)
        |> assign(:selected_team, team)
    end
  end

  defp apply_action(socket, :code, params) do
    tab = Map.get(params, "tab", "join")

    socket
    |> assign(:tab, tab)
    |> assign(:code_form, to_form(%{"code" => ""}, as: "team_code"))
  end

  @impl true
  def handle_event("save", %{"team" => team_params}, socket) do
    case Teams.create_and_join_team(socket.assigns.user, team_params) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team created successfully!")
         |> push_navigate(to: ~p"/app/profile")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  @impl true
  def handle_event("submit_code", %{"team_code" => %{"code" => code} = params}, socket) do
    case Teams.add_user_to_team_by_code(
           socket.assigns.user,
           code |> String.trim() |> String.upcase()
         ) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Successfully joined the team!")
         |> push_navigate(to: ~p"/app/profile")}

      {:error, reason} ->
        code_form =
          to_form(params, as: "team_code", errors: [code: {team_join_error(reason), []}])

        {:noreply, assign(socket, :code_form, code_form)}
    end
  end

  @impl true
  def handle_event("join-team", %{"team_code" => team_code}, socket) do
    case Teams.add_user_to_team_by_code(socket.assigns.user, team_code) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Successfully joined the team!")
         |> push_navigate(to: ~p"/app/profile")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to join team. " <> team_join_error(reason))}
    end
  end

  @impl true
  def handle_event("validate", %{"team" => team_params}, socket) do
    changeset = Teams.change_team(%Teams.Team{}, team_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "team")
    assign(socket, form: form)
  end

  defp team_join_error(:not_found), do: "Team not found."
  defp team_join_error(:unavailable), do: "This team is not accepting new members."
  defp team_join_error(%Ecto.Changeset{}), do: "Could not join this team."
end
