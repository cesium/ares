defmodule AresWeb.Backoffice.CompaniesFormComponent do
  @moduledoc """
  Form component for creating and editing companies.
  """
  use AresWeb, :live_component

  alias Ares.Companies
  alias Ares.Uploaders
  alias Ares.Uploaders.Company

  import AresWeb.Components.ImageUploader

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>
          {gettext("Companies sponsor the event.")}
        </:subtitle>
      </.header>

      <.form
        for={@form}
        id="company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        autocomplete="off"
      >
        <div>
          <div class="grid grid-cols-2">
            <.input field={@form[:name]} type="text" label="Name" required />
            <.input field={@form[:url]} type="text" label="URL" />
          </div>
          <div class="w-full">
            <label>Logo</label>
            <p class="text-sm mb-4">
              {gettext("For better results, upload a white logo with a transparent background.")}
            </p>
            <.image_uploader
              class="w-full h-80"
              image_class="h-80 p-16 bg-dark hover:bg-dark/90 w-full transition-colors rounded-xl"
              icon="hero-building-office"
              upload={@uploads.logo}
              image={Uploaders.Company.url({@company.logo, @company}, :original, signed: true)}
            />
          </div>
        </div>
        <button phx-disable-with="Saving...">Save Company</button>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:logo,
       accept: Company.extension_whitelist(),
       max_entries: 1
     )}
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:company, company)
     |> assign_new(:form, fn ->
       to_form(Companies.change_company(company))
     end)}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset = Companies.change_company(socket.assigns.company, company_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, company_params)
  end

  defp save_company(socket, company_params) do
    case Companies.create_or_update_company(socket.assigns.company, company_params) do
      {:ok, company} ->
        case consume_image_data(company, socket) do
          {:ok, _company} ->
            {:noreply,
             socket
             |> put_flash(:info, "Company updated successfully")
             |> push_patch(to: socket.assigns.patch)}
        end

      {:error, _, _, _} ->
        {:noreply, :error}
    end
  end

  defp consume_image_data(company, socket) do
    consume_uploaded_entries(socket, :logo, fn %{path: path}, entry ->
      Companies.update_company_logo(company, %{
        "logo" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)
    |> case do
      [{:ok, company}] ->
        {:ok, company}

      _errors ->
        {:ok, company}
    end
  end
end
