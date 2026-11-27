defmodule AresWeb.BackofficeLive.Companies do
  use AresWeb, :backoffice_view

  alias Ares.Companies
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    companies = Ares.Companies.list_companies() |> Enum.map(&{&1.id, &1})

    {:ok,
     socket
     |> assign(:companies, companies)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Companies.get_company!(id)
    {:ok, _} = Companies.delete_company(company)

    companies = Ares.Companies.list_companies() |> Enum.map(&{&1.id, &1})

    {:noreply, assign(socket, :companies, companies)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:company, Companies.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Companies.Company{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Companies")
    |> assign(:company, nil)
  end
end
