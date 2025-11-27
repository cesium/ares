defmodule BugsbyteWeb.PageController do
  use BugsbyteWeb, :controller

  alias Bugsbyte.Teams
  alias Bugsbyte.Users

  def create_team(conn, %{"team" => team_params}) do
    case Teams.create_team(team_params) do
      {:ok, _team} ->
        conn
        |> put_flash(:info, "Team created successfully!")
        |> redirect(to: "/teams")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create team. Please check the form and try again.")
        |> redirect(to: "/team-formation?tab=create")
    end
  end
  def create_team(conn, _params) do
    conn
    |> put_flash(:error, "Invalid team data.")
    |> redirect(to: "/team-formation?tab=create")
  end

  def join_team(conn, %{"team_code" => team_code}) do
    user_id = get_session(conn, "user_id")

    case user_id && Users.get_user(user_id) do
      {:ok, user} ->
        # Update user with team_code
        case Users.update_user(user, %{"team_code" => team_code}) do
          {:ok, _updated_user} ->
            conn
            |> put_flash(:info, "Successfully joined the team!")
            |> redirect(to: "/teams")

          {:error, _changeset} ->
            conn
            |> put_flash(:error, "Failed to join team. Please try again.")
            |> redirect(to: "/team-formation?tab=join")
        end

      _ ->
        conn
        |> put_flash(:error, "You must be logged in to join a team.")
        |> redirect(to: "/register")
    end
  end

  def join_team(conn, _params) do
    conn
    |> put_flash(:error, "Invalid join request.")
    |> redirect(to: "/team-formation?tab=join")
  end

  def register(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Registration successful!")
        |> redirect(to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Registration failed. Please check your information and try again.")
        |> redirect(to: "/register")
    end
  end

  def register(conn, _params) do
    conn
    |> put_flash(:error, "Invalid registration data.")
    |> redirect(to: "/register")
  end
end
