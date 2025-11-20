defmodule BugsbyteWeb.App.HomeLive.Index do
  use BugsbyteWeb, :app_view

  alias Bugsbyte.Companies
  alias Bugsbyte.Gallery

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
