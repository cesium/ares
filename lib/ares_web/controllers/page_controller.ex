defmodule AresWeb.PageController do
  use AresWeb, :controller

  alias Ares.Teams
  alias Ares.Users

  def join_team(conn, %{"team_code" => team_code}) do
    user_id = get_session(conn, "user_id")

    with {:ok, user} <- get_authenticated_user(conn, user_id),
         :ok <- validate_not_admin(user) do
      update_user_team_code(conn, user, team_code)
    else
      {:error, :unauthenticated} ->
        conn
        |> put_flash(:error, "You must be logged in to join a team.")
        |> redirect(to: "/register")

      {:error, :admin_not_allowed} ->
        conn
        |> put_flash(:error, "Admins cannot join teams.")
        |> redirect(to: "/team-formation")
    end
  end

  def create_team(conn, params) do
    user_id = get_session(conn, "user_id")

    with {:ok, user} <- get_authenticated_user(conn, user_id),
         :ok <- validate_not_admin(user),
         {:ok, team} <- create_team_with_code(params["team"]),
         {:ok, _updated_user} <- Users.update_user(user, %{"team_code" => team.code}) do
      conn
      |> put_flash(:info, "Successfully created the team!")
      |> redirect(to: "/teams")
    else
      {:error, :unauthenticated} ->
        conn
        |> put_flash(:error, "You must be logged in to create a team.")
        |> redirect(to: "/register")

      {:error, :admin_not_allowed} ->
        conn
        |> put_flash(:error, "Admins cannot create a team.")
        |> redirect(to: "/team-formation")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Failed to create team: #{inspect(changeset.errors)}")
        |> redirect(to: "/team-formation")

      {:error, :failed_to_join} ->
        conn
        |> put_flash(:error, "Failed to join your new team. Please try again.")
        |> redirect(to: "/team-formation")
    end
  end

  defp get_authenticated_user(_conn, nil), do: {:error, :unauthenticated}

  defp get_authenticated_user(_conn, user_id) do
    {:ok, Users.get_user!(user_id)}
  end

  defp validate_not_admin(%{is_admin: true}), do: {:error, :admin_not_allowed}
  defp validate_not_admin(_user), do: :ok

  defp update_user_team_code(conn, user, team_code) do
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

  defp create_team_with_code(team_params) do
    team_count = Teams.count_teams()
    team_code = "TEAM#{String.pad_leading(Integer.to_string(team_count + 1), 3, "0")}"
    completed_team = Map.put(team_params, "code", team_code)

    case Teams.create_team(completed_team) do
      {:ok, team} -> {:ok, team}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
