defmodule BugsbyteWeb.App.HomeLive.Index do
  use BugsbyteWeb, :app_view

  alias Bugsbyte.Companies
  alias Bugsbyte.Gallery
  alias Bugsbyte.Users

  @impl true
  def mount(_params, session, socket) do
    sponsors = Companies.get_sponsors()
    supporters = Companies.get_supporters()
    gallery_images = Gallery.get_gallery_images()

    user_id = session["user_id"]
    user = if user_id, do: Users.get_user!(user_id), else: nil

    socket =
      socket
      |> assign(:sponsors, sponsors)
      |> assign(:supporters, supporters)
      |> assign(:gallery_images, gallery_images)
      |> assign(:user, user)

    {:ok, socket}
  end
end
