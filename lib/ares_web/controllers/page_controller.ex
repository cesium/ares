defmodule AresWeb.PageController do
  use AresWeb, :controller

  alias Ares.Users

  def join_team(conn, %{"team_code" => team_code}) do
    user_id = get_session(conn, "user_id")

    if user_id do
      user = Users.get_user!(user_id)

      # Check if user is admin
      if user.is_admin do
        conn
        |> put_flash(:error, "Admins cannot join teams.")
        |> redirect(to: "/team-formation")
      else
        # Update the user with the team code
        case Users.update_user(user, %{"team_code" => team_code}) do
          {:ok, _updated_user} ->
            conn
            |> put_flash(:info, "Successfully joined the team!")
            |> redirect(to: "/teams")

          {:error, _changeset} ->
            conn
            |> put_flash(:error, "Failed to join team. Please try again.")
            |> redirect(to: "/team-formation")
        end
      end
    else
      conn
      |> put_flash(:error, "You must be logged in to join a team.")
      |> redirect(to: "/register")
    end
  end

  def create_team(conn, _params) do
    # Placeholder for team creation logic
    conn
    |> put_flash(:info, "Team creation not implemented yet")
    |> redirect(to: "/teams")
  end
end
