defmodule AresWeb.App.ProfileLive.Index do
  use AresWeb, :app_view

  alias Ares.Teams
  alias Ares.Users

  @impl true
  def mount(_params, session, socket) do
    user_id = session["user_id"]

    user =
      case user_id && Users.get_user(user_id) do
        {:ok, u} -> u
        _ -> nil
      end

    if user do
      changeset = Users.change_user(user)

      # Load user's team if they have a team_code
      user_team = if user.team_code, do: Teams.get_team_by_code(user.team_code), else: nil

      # Load team members (users with the same team_code)
      team_members = if user_team, do: Users.list_users_by_team_code(user_team.code), else: []

      socket =
        socket
        |> assign(:user, user)
        |> assign(:changeset, changeset)
        |> assign(:user_team, user_team)
        |> assign(:team_members, team_members)

      {:ok, socket}
    else
      {:ok,
       socket
       |> put_flash(:error, "You must be logged in to view your profile.")
       |> redirect(to: "/")}
    end
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    user = socket.assigns.user

    case Users.update_user(user, user_params) do
      {:ok, updated_user} ->
        socket =
          socket
          |> put_flash(:info, "Profile updated successfully!")
          |> assign(:user, updated_user)
          |> assign(:changeset, Users.change_user(updated_user))
          |> redirect(to: "/profile")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :changeset, changeset)
        {:noreply, socket}
    end
  end
end
