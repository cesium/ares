defmodule Bugsbyte.Faqs do
  @moduledoc """
  Context for handling FAQ data.
  """

  @faqs_path "priv/static/images/data/faqs.json"

  @doc """
  Gets all FAQ items from the JSON file
  """
  def get_faqs do
    with {:ok, content} <- File.read(@faqs_path),
         {:ok, faqs} <- Jason.decode(content) do
      build_faqs(faqs)
    else
      _ -> []
    end
  end

  defp build_faqs(faqs) do
    faqs
    |> Enum.with_index(1)
    |> Enum.map(fn {faq, index} ->
      Map.put(faq, "id", index)
      |> Map.put("expanded", false)
    end)
  end

  @doc """
  Gets a specific FAQ by ID
  """
  def get_faq_by_id(id) do
    get_faqs()
    |> Enum.find(fn faq -> faq["id"] == id end)
  end
end
