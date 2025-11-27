defmodule Ares.Gallery do
  @moduledoc """
  Context for handling gallery images.
  """

  @gallery_path "priv/static/images/gallery"

  @doc """
  Gets all gallery images ending with "-2025.jpg"
  """
  def get_gallery_images do
    case File.ls(@gallery_path) do
      {:ok, files} ->
        files
        |> Enum.filter(&String.ends_with?(&1, "-2025.jpg"))
        |> Enum.sort()
        |> Enum.map(&gallery_image_path/1)

      {:error, _reason} ->
        []
    end
  end

  @doc """
  Returns the full path for a gallery image
  """
  def gallery_image_path(filename) do
    "/images/gallery/#{filename}"
  end
end
