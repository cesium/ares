defmodule Ares.Repo.Seeds.Companies do

  alias Ares.Companies

  def run do
    case Companies.list_companies() do
      [] ->
        seed_companies()
      _  ->
        Mix.shell().error("Found companies, aborting seeding companies.")
    end
  end

  defp seed_companies do
    for _ <- 1..4 do
      attrs = %{
        name: Faker.Company.name(),
        url: Faker.Internet.url()
      }

      case Companies.create_company(attrs) do
        {:ok, company} ->
          Mix.shell().info("Created company #{company.name}")

        {:error, changeset} ->
          Mix.shell().error("Error creating company: " <> Kernel.inspect(changeset.errors))
      end
    end
  end
end

Ares.Repo.Seeds.Companies.run()
