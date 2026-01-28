defmodule AresWeb.BackofficeLive.Companies do
  use AresWeb, :live_view

  alias Ares.Companies
  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-4">
      <.link
        patch={~p"/backoffice/companies/new"}
        class="mb-4 inline-block bg-primary hover:bg-primaryDark text-white font-semibold py-2 px-4 rounded"
      >
        New Company
      </.link>
      <.table id="companies-table" rows={@companies}>
        <:col :let={{_id, company}} label="Name">{company.name}</:col>
        <:col :let={{_id, company}} label="Url">
          {company.url}
        </:col>
        <:action :let={{id, company}}>
          <div class="flex flex-row gap-2">
            <.link patch={~p"/backoffice/companies/#{company.id}/edit"}>
              <.icon name="hero-pencil" class="w-5 h-5" />
            </.link>
            <.link
              phx-click={JS.push("delete", value: %{id: company.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              <.icon name="hero-trash" class="w-5 h-5" />
            </.link>
          </div>
        </:action>
      </.table>
    </div>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="company-modal"
      show
      on_cancel={JS.patch(~p"/backoffice/companies")}
    >
      <.live_component
        module={AresWeb.Backoffice.CompaniesFormComponent}
        id={@company.id || :new}
        title={@page_title}
        action={@live_action}
        company={@company}
        patch={~p"/backoffice/companies"}
      />
    </.modal>
    """
  end

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
