defmodule AresWeb.LandingLive.Home do
  use AresWeb, :live_view
  import AresWeb.Components.SquigglyEffect

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:sponsors, [])
      |> assign(:supporters, [])
      |> assign(:gallery_images, [])
      |> assign(:user, nil)

    {:ok, socket}
  end
end
