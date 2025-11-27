defmodule Ares.Companies do
  @moduledoc """
  Context for handling companies data from JSON file.
  """

  @companies_file "priv/static/images/data/companies.json"

  @doc """
  Returns all companies data from JSON file.
  """
  def get_companies do
    case File.read(@companies_file) do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, data} -> {:ok, data}
          {:error, _} -> {:error, "Failed to parse JSON"}
        end

      {:error, _} ->
        {:error, "Failed to read companies file"}
    end
  end

  @doc """
  Returns list of sponsors.
  """
  def get_sponsors do
    case get_companies() do
      {:ok, %{"sponsors" => sponsors}} -> sponsors
      _ -> []
    end
  end

  @doc """
  Returns list of supporters.
  """
  def get_supporters do
    case get_companies() do
      {:ok, %{"supporters" => supporters}} -> supporters
      _ -> []
    end
  end

  @doc """
  Prepends /images/ to icon path if not already present.
  """
  def icon_path(icon) when is_binary(icon) do
    if String.starts_with?(icon, "/images/") do
      icon
    else
      "/images/#{icon}.svg"
    end
  end

  def icon_path(_), do: ""
end
