defmodule Ares.CompaniesTest do
  use Ares.DataCase

  alias Ares.Companies

  describe "companies" do
    alias Ares.Companies.Company

    import Ares.CompaniesFixtures

    @invalid_attrs %{name: nil, url: nil, logo: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name", url: "some url"}

      assert {:ok, %Company{} = company} = Companies.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.url == "some url"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()

      update_attrs = %{
        name: "some updated name",
        url: "some updated url"
      }

      assert {:ok, %Company{} = company} = Companies.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.url == "some updated url"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end
end
