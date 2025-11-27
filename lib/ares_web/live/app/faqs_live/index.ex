defmodule AresWeb.App.FaqsLive.Index do
  use AresWeb, :app_view

  alias Ares.Faqs

  @impl true
  def mount(_params, _session, socket) do
    faqs = Faqs.get_faqs()
    socket = assign(socket, :faqs, faqs)
    {:ok, socket}
  end
end
