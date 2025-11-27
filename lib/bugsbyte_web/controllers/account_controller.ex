defmodule BugsbyteWeb.AccountController do
  use BugsbyteWeb, :controller

  alias Bugsbyte.Users

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Account created successfully!")
        |> redirect(to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create account. Please check your information.")
        |> redirect(to: "/register")
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "Invalid registration data.")
    |> redirect(to: "/register")
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Users.get_user_by_email(email) do
      {:ok, user} ->
        if verify_password(user, password) do
          conn
          |> put_session(:user_id, user.id)
          |> put_flash(:info, "Login successful!")
          |> redirect(to: "/")
        else
          conn
          |> put_flash(:error, "Invalid email or password.")
          |> redirect(to: "/register")
        end

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> redirect(to: "/register")
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: "/")
  end

  defp verify_password(_user, _password) do
    # For now, accept any password. In production, use bcrypt or similar
    true
  end
end
