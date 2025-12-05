defmodule AresWeb.Components.CVUpload do
  @moduledoc """
  Attendee Curriculum Vitae upload component.
  """
  use AresWeb, :live_component

  alias Ares.Uploaders.CV
  alias Ares.Users

  import AresWeb.Components.ImageUploader

  attr :in_app, :boolean, default: false

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="attendee-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="flex flex-col md:flex-row w-full gap-4">
          <div class="w-full">
            <.image_uploader class="h-40" upload={@uploads.cv} show_errors={false}>
              <:placeholder>
                <div class="select-none flex flex-col gap-2 items-center text-gray-400">
                  <.icon name="hero-arrow-up-tray" class="w-12 h-12" />
                  <p class="px-4 text-center">Upload your Curriculum Vitae</p>
                </div>
              </:placeholder>
            </.image_uploader>

            <div :if={@current_user.cv} class="mt-4 pt-3 border-t border-gray-700">
              <p class="text-sm text-gray-400">
                {gettext("Current CV: ")}
                <span class="text-white font-medium">{@current_user.cv.file_name}</span>
              </p>
              <p class="text-sm text-gray-400 mt-1">
                {gettext("You can replace your current CV by uploading again.")}
              </p>
            </div>

            <%= for entry <- @uploads.cv.entries do %>
              <%= for err <- upload_errors(@uploads.cv, entry) do %>
                <div class="mt-3 flex items-center gap-2 text-sm text-pink">
                  <.icon name="hero-exclamation-circle" class="w-5 h-5 flex-shrink-0" />
                  <span>{Phoenix.Naming.humanize(err)}</span>
                </div>
              <% end %>
            <% end %>

            <%= for err <- upload_errors(@uploads.cv) do %>
              <div class="mt-3 flex items-center gap-2 text-sm text-pink">
                <.icon name="hero-exclamation-circle" class="w-5 h-5 flex-shrink-0" />
                <span>{Phoenix.Naming.humanize(err)}</span>
              </div>
            <% end %>
          </div>
        </div>
        <:actions>
          <%= if @in_app do %>
            <.button
              class="flex-1 bg-primary text-white py-3 px-6 rounded-lg hover:bg-primary/50 transition-colors cursor-pointer text-lg"
              phx-disable-with="Uploading..."
            >
              Upload
            </.button>
          <% else %>
            <.button phx-disable-with="Uploading...">Upload</.button>
          <% end %>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:cv,
       accept: CV.extension_whitelist(),
       max_entries: 1
     )}
  end

  @impl true
  def update(%{current_user: user} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Users.change_user_profile(user))
     end)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{}, socket) do
    save_user(socket, %{})
  end

  defp save_user(socket, user_params) do
    case Users.update_user(socket.assigns.current_user, user_params) do
      {:ok, user} ->
        case consume_pdf_data(user, socket) do
          {:ok, updated_user} ->
            {:noreply,
             socket
             |> put_flash(:info, "CV uploaded successfully.")
             |> assign(current_user: Map.put(socket.assigns.current_user, :cv, updated_user.cv))
             |> push_patch(to: socket.assigns.patch)}

          {:error, reason} ->
            {:noreply,
             socket
             |> put_flash(:error, reason)
             |> push_patch(to: socket.assigns.patch)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp consume_pdf_data(user, socket) do
    consume_uploaded_entries(socket, :cv, fn %{path: path}, entry ->
      Users.update_user_cv(user, %{
        "cv" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
      |> case do
        {:ok, user} ->
          {:ok, user}

        {:error, _changeset} ->
          {:error, "An error occurred while updating the user."}
      end
    end)
    |> case do
      [] ->
        {:error, "Select a file to upload."}

      [error: _message] ->
        {:error, "An error occurred while uploading the file."}

      [user] ->
        {:ok, user}
    end
  end
end
