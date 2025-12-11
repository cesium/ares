defmodule AresWeb.App.AccountLive.Index do
  use AresWeb, :app_view

  alias Ares.Users

  @impl true
  def mount(_params, session, socket) do
    user_id = session["user_id"]

    user =
      case user_id && Users.get_user(user_id) do
        {:ok, u} -> u
        _ -> nil
      end

    socket =
      socket
      |> assign(:user, user)
      |> assign(:tab, "register")
      |> allow_upload(:cv,
        accept: ~w(.pdf),
        max_entries: 1,
        max_file_size: 5_000_000
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, socket |> assign(:tab, tab)}
  end
end
