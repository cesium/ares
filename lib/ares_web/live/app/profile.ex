defmodule AresWeb.AppLive.Profile do
  use AresWeb, :app_view

  on_mount {AresWeb.UserAuth, :require_authenticated}

  alias Ares.Accounts
  alias Ares.Accounts.User
  alias Ares.Teams
  alias AresWeb.Components.CVUploader

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    team =
      if user.team_id do
        Teams.get_team!(user.team_id)
      else
        nil
      end

    changeset = Accounts.change_user(%User{}, %{}, validate_unique: false)

    {:ok,
     socket
     |> assign(user: Map.put(user, :team, team))
     |> assign_form(changeset)
     |> assign(:cv_uploading, false)
     |> assign(:cv_upload_error, nil)
     |> allow_upload(:cv,
       accept: ~w(.pdf .doc .docx .txt .md .rtf),
       max_entries: 1,
       max_file_size: 5_000_000,
       auto_upload: true,
       progress: &handle_progress/3
     )}
  end

  def handle_event("remove-cv", _params, socket) do
    user = socket.assigns.user

    case Accounts.update_user_cv(user, %{"cv" => nil}) do
      {:ok, %Accounts.User{} = updated_user} ->
        {:noreply,
         socket
         |> assign(user: updated_user)
         |> put_flash(:info, "CV removed.")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Could not remove CV.")}
    end
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref} = _params, socket) do
    {:noreply, socket |> cancel_upload(:cv, ref) |> assign(:cv_upload_error, nil)}
  end

  @impl true
  def handle_event("validate", %{"_target" => _} = _params, socket) do
    upload_errors = upload_errors(socket.assigns.uploads.cv) || []
    {:noreply, socket |> assign(:cv_upload_error, upload_errors)}
  end

  def handle_event("save", _params, socket) do
    user = socket.assigns.user

    if socket.assigns.cv_uploading do
      {:noreply, socket |> put_flash(:error, "CV upload still in progress. Please wait.")}
    else
      case consume_pdf_data(socket, {:ok, user}) do
        {:ok, %Accounts.User{} = updated_user} ->
          {:noreply,
           socket
           |> assign(user: updated_user)
           |> put_flash(:info, "CV uploaded successfully.")}

        {:ok, _} ->
          {:noreply, put_flash(socket, :info, "Nothing to upload.")}

        {:error, reason} ->
          {:noreply, put_flash(socket, :error, "CV upload failed: #{inspect(reason)}")}
      end
    end
  end

  defp consume_pdf_data(socket, {:ok, user}) do
    result =
      consume_uploaded_entries(socket, :cv, fn %{path: path}, entry ->
        Accounts.update_user_cv(user, %{
          "cv" => %Plug.Upload{
            content_type: entry.client_type,
            filename: entry.client_name,
            path: path
          }
        })
      end)

    case result do
      [] ->
        {:ok, user}

      [error: reason] ->
        {:error, reason}

      [updated_user] ->
        {:ok, updated_user}

      _ ->
        {:ok, socket}
    end
  end

  defp consume_pdf_data(_socket, result) do
    result
  end

  def handle_progress(:cv, entry, socket) do
    uploading = entry.progress < 100
    errors = upload_errors(socket.assigns.uploads.cv) || []

    {:noreply,
     socket
     |> assign(:cv_uploading, uploading)
     |> assign(:cv_upload_error, if(errors == [], do: nil, else: errors))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
