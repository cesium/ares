defmodule BugsbyteWeb.AccountController do
  use BugsbyteWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> put_flash(:info, "Account created for #{user_params["email"]}")
    |> redirect(to: "/")
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "Invalid registration")
    |> redirect(to: "/register")
  end
end
