defmodule AresWeb.App.AccountLive.Index do
  use AresWeb, :app_view

  # No component-specific server-side logic needed here; remove unused aliases

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
