defmodule AresWeb.App.TeamFormationLive.Index do
  use AresWeb, :app_view

  alias Ares.Teams
  alias Ares.Users

  @impl true
  def mount(params, session, socket) do
    changeset = Teams.change_team(%Teams.Team{})
    tab = Map.get(params, "tab", "create")
    user_id = session["user_id"]
    user = if user_id, do: Users.get_user!(user_id), else: nil

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

  @impl true
  def handle_event("join_team", %{"team_code" => team_code}, socket) do
    user = socket.assigns.user

    if user do
      case Users.update_user(user, %{"team_code" => team_code}) do
        {:ok, _updated_user} ->
          socket =
            socket
            |> put_flash(:info, "Successfully joined the team!")
            |> redirect(to: "/teams")

          {:noreply, socket}

        {:error, _changeset} ->
          socket = put_flash(socket, :error, "Failed to join team. Please try again.")
          {:noreply, socket}
      end
    else
      socket =
        socket
        |> put_flash(:error, "You must be logged in to join a team.")
        |> redirect(to: "/register")

      {:noreply, socket}
    end
  end
end
