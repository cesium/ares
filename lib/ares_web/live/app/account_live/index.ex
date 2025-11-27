defmodule AresWeb.App.AccountLive.Index do
  use AresWeb, :app_view

  alias Ares.Users

  @impl true
  def mount(_params, session, socket) do
    user_id = session["user_id"]
    user = if user_id, do: Users.get_user!(user_id), else: nil

    socket =
      socket
      |> assign(:user, user)
      |> assign(:tab, "register")

    {:ok, socket}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, socket |> assign(:tab, tab)}
  end
end
