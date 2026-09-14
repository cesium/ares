defmodule AresWeb.LandingLive.Gallery do
  use AresWeb, :live_view

  import AresWeb.Components.LandingSection

  @impl true
  def mount(_params, _session, socket) do
    images =
      :ares
      |> Application.app_dir("priv/static/images/gallery")
      |> Path.join("*.JPG")
      |> Path.wildcard()
      |> Enum.sort()
      |> Enum.map(&Path.join("/images/gallery", Path.basename(&1)))

    {:ok, assign(socket, :images, images)}
  end
end
