defmodule BugsbyteWeb.App.FaqsLive.Index do
  use BugsbyteWeb, :app_view

  alias Bugsbyte.Faqs
  alias Bugsbyte.Users

  @impl true
  def mount(_params, session, socket) do
    faqs = Faqs.get_faqs()
    user_id = session["user_id"]
    user = if user_id, do: Users.get_user!(user_id), else: nil
    socket = socket |> assign(:faqs, faqs) |> assign(:user, user)
    {:ok, socket}
  end
end
