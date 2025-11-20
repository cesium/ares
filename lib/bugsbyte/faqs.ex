defmodule Bugsbyte.Faqs do
  @moduledoc """
  Context for handling FAQ data.
  """

  @faqs_path "priv/static/images/data/faqs.json"

  @doc """
  Gets all FAQ items from the JSON file
  """
  def get_faqs do
    case File.read(@faqs_path) do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, faqs} ->
            faqs
            |> Enum.with_index(1)
            |> Enum.map(fn {faq, index} ->
              Map.put(faq, "id", index)
              |> Map.put("expanded", false)
            end)
          {:error, _reason} -> []
        end

      {:error, _reason} ->
        []
    end
  end

  @doc """
  Gets a specific FAQ by ID
  """
  def get_faq_by_id(id) do
    get_faqs()
    |> Enum.find(fn faq -> faq["id"] == id end)
  end
end
