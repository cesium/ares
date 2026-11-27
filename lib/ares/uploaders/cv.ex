defmodule Ares.Uploaders.CV do
  @moduledoc """
  Uploader for profile pictures.
  """
  use Ares.Uploader

  @versions [:original]
  @extension_whitelist ~w(.pdf .doc .docx .txt .md .rtf)

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(extension_whitelist(), file_extension)
  end

  def storage_dir(_, {_file, %{id: id}}) do
    "uploads/attendees/cvs/#{id}"
  end

  def filename(version, _) do
    version
  end

  def extension_whitelist do
    @extension_whitelist
  end
end
