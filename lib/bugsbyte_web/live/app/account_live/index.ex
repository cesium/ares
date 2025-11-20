defmodule BugsbyteWeb.App.AccountLive.Index do
  use BugsbyteWeb, :app_view

  alias BugsbyteWeb.NavComponent
  alias BugsbyteWeb.FooterComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
