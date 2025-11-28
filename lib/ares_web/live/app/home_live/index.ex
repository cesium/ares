defmodule AresWeb.App.HomeLive.Index do
  use AresWeb, :app_view

  alias Ares.Companies
  alias Ares.Gallery
  alias Ares.Users

  @impl true
  def mount(_params, session, socket) do
    sponsors = Companies.get_sponsors()
    supporters = Companies.get_supporters()
    gallery_images = Gallery.get_gallery_images()

    user_id = session["user_id"]
    user =
      case user_id && Users.get_user(user_id) do
        {:ok, u} -> u
        _ -> nil
      end

    socket =
      socket
      |> assign(:sponsors, sponsors)
      |> assign(:supporters, supporters)
      |> assign(:gallery_images, gallery_images)
      |> assign(:user, user)

    {:ok, socket}
  end
end
