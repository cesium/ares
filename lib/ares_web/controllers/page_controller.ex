defmodule AresWeb.PageController do
  use AresWeb, :controller

  alias Ares.Users
  alias Ares.Teams
  alias Ares.Teams.Team

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

  def create_team(conn, params) do
    user_id = get_session(conn, "user_id")

    if user_id do
      user = Users.get_user!(user_id)

      if user.is_admin do
        conn
        |> put_flash(:error, "Admins cannot create a team.")
        |> redirect(to: "/team-formation")
      else
        team_params = params["team"]
        team_count = Teams.count_teams()
        team_code = "TEAM#{String.pad_leading(Integer.to_string(team_count + 1), 3, "0")}"
        completed_team = Map.put(team_params, "code", team_code)

        case Teams.create_team(completed_team) do
          {:ok, team} ->
            IO.inspect(team)
            case Users.update_user(user, %{"team_code" => team.code}) do
              {:ok, _updated_user} ->
                conn
                |> put_flash(:info, "Successfully created the team!")
                |> redirect(to: "/teams")

              {:error, _changeset} ->
                conn
                |> put_flash(:error, "Failed to join your new team. Please try again.")
                |> redirect(to: "/team-formation")
            end

          {:error, changeset} ->
            conn
            |> put_flash(:error, "Failed to create team: #{inspect(changeset.errors)}")
            |> redirect(to: "/team-formation")
        end
      end
    else
      conn
      |> put_flash(:error, "You must be logged in to create a team.")
      |> redirect(to: "/register")
    end
  end
end
