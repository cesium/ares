defmodule BugsbyteWeb.App.FaqsLive.Index do
  use BugsbyteWeb, :app_view

  alias Bugsbyte.Faqs

  @impl true
  def mount(_params, _session, socket) do
    faqs = Faqs.get_faqs()
    socket = assign(socket, :faqs, faqs)
    {:ok, socket}
  end
end
