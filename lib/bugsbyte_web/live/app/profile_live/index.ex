defmodule BugsbyteWeb.App.ProfileLive.Index do
  use BugsbyteWeb, :app_view

  alias Bugsbyte.Teams
  alias Bugsbyte.Users

  @impl true
  def mount(_params, session, socket) do
    user_id = session["user_id"]

    case user_id && Users.get_user(user_id) do
      {:ok, user} ->
        changeset = Users.change_user(user)

        # Load user's team if they have a team_code
        user_team = if user.team_code, do: Teams.get_team_by_code(user.team_code), else: nil

        socket =
          socket
          |> assign(:user, user)
          |> assign(:changeset, changeset)
          |> assign(:user_team, user_team)

        {:ok, socket}

      _ ->
        {:ok,
         socket
         |> put_flash(:error, "You must be logged in to view your profile.")
         |> redirect(to: "/")}
    end
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        socket =
          socket
          |> put_flash(:info, "Profile updated successfully!")
          |> assign(:user, user)
          |> assign(:changeset, Users.change_user(user))
          |> redirect(to: "/")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :changeset, changeset)
        {:noreply, socket}
    end
  end
end
