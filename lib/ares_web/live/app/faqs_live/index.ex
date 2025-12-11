defmodule AresWeb.App.FaqsLive.Index do
  use AresWeb, :app_view

  alias Ares.Faqs
  alias Ares.Users

  @impl true
  def mount(_params, session, socket) do
    faqs = Faqs.get_faqs()
    user_id = session["user_id"]

    user =
      case user_id && Users.get_user(user_id) do
        {:ok, u} -> u
        _ -> nil
      end

    socket = socket |> assign(:faqs, faqs) |> assign(:user, user)
    {:ok, socket}
  end
end
