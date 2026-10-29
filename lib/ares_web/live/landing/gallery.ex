defmodule AresWeb.LandingLive.Gallery do
  use AresWeb, :landing_view

  import AresWeb.Components.Page

  @impl true
  def mount(_params, _session, socket) do
    images =
      :ares
      |> Application.app_dir("priv/static/images/gallery")
      |> Path.join("*.JPG")
      |> Path.wildcard()
      # phx.digest writes fingerprinted copies (NAME-<md5>.JPG) next to the originals
      |> Enum.reject(&Regex.match?(~r/-[0-9a-f]{32}\.JPG$/, &1))
      |> Enum.sort()
      |> Enum.map(&Path.join("/images/gallery", Path.basename(&1)))

    {:ok, assign(socket, :images, images)}
  end
end
