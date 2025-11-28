defmodule AresWeb.AuthController do
  use AresWeb, :controller

  alias Ares.Users

  def login(conn, _params) do
    render(conn, :login, changeset: nil)
  end

  def login_submit(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Login successful!")
        |> redirect(to: ~p"/")

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: ~p"/auth/login")
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: ~p"/auth/login")
  end

  def register(conn, _params) do
    changeset = Users.change_user(%Ares.Users.User{})
    render(conn, :register, changeset: changeset)
  end

  def register_submit(conn, %{"user" => user_params}) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Account created successfully! Welcome!")
        |> redirect(to: ~p"/")

      {:error, changeset} ->
        render(conn, :register, changeset: changeset)
    end
  end
end
