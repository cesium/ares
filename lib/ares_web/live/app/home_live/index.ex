defmodule AresWeb.App.HomeLive.Index do
  use AresWeb, :app_view

  alias Ares.Companies
  alias Ares.Gallery

  @impl true
  def mount(_params, _session, socket) do
    sponsors = Companies.get_sponsors()
    supporters = Companies.get_supporters()
    gallery_images = Gallery.get_gallery_images()

    socket =
      socket
      |> assign(:sponsors, sponsors)
      |> assign(:supporters, supporters)
      |> assign(:gallery_images, gallery_images)

    {:ok, socket}
  end
end
