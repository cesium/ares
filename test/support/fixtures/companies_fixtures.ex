defmodule Ares.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ares.Companies` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        logo: "some logo",
        name: "some name",
        url: "some url",
        type: :sponsor
      })
      |> Ares.Companies.create_company()

    company
  end
end
