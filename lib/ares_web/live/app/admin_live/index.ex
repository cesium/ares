defmodule AresWeb.App.AdminLive.Index do
  use AresWeb, :live_view

  alias Ares.Teams
  alias Ares.Users

  @impl true
  def mount(_params, session, socket) do
    user_id = session["user_id"]

    socket =
      socket
      |> assign(:page_title, "Admin Dashboard")
      |> assign(:csrf_token, session["csrf_token"] || Plug.CSRFProtection.get_csrf_token())

    case user_id && Users.get_user(user_id) do
      {:ok, user} ->
        if user.is_admin do
          teams = Teams.list_teams()

          {:ok,
           socket
           |> assign(:user, user)
           |> assign(:teams, teams)
           |> assign(:error, nil)}
        else
          {:ok,
           socket
           |> assign(:user, user)
           |> assign(:error, "You don't have admin permissions.")}
        end

      _ ->
        {:ok,
         socket
         |> assign(:user, nil)
         |> assign(:error, "You must be logged in to access the admin dashboard.")}
    end
  end
end
