defmodule AresWeb.UserLive.Registration do
  use AresWeb, :app_view

  alias Ares.Accounts
  alias Ares.Accounts.User
  alias Ares.Event
  alias AresWeb.Components.CVUploader

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: AresWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    if Event.registrations_open?() do
      changeset = Accounts.change_user(%User{}, %{}, validate_unique: false)

      {:ok,
       socket
       |> assign_form(changeset)
       |> allow_upload(:cv,
         accept: ~w(.pdf .doc .docx .txt .md .rtf),
         max_entries: 1,
         max_file_size: 5_000_000,
         auto_upload: true,
         progress: &handle_progress/3
       )}
    else
      {:ok, redirect(socket, to: "/log-in")}
    end
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref} = _params, socket) do
    {:noreply, cancel_upload(socket, :cv, ref)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    if Event.registrations_open?() do
      with {:ok, user} <- Accounts.register_user(user_params, &consume_pdf_data(socket, &1)),
           {:ok, _} <- Accounts.deliver_login_instructions(user, &url(~p"/log-in/#{&1}")) do
        {:noreply,
         socket
         |> put_flash(
           :info,
           "An email was sent to #{user.email}, please access it to confirm your account."
         )
         |> push_navigate(to: ~p"/log-in")}
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign_form(socket, changeset)}
      end
    else
      {:noreply,
       socket
       |> put_flash(:error, "Registration is closed.")
       |> assign_form(Accounts.change_user(%User{}, user_params))}
    end
  end

  def handle_progress(:cv, _entry, socket) do
    {:noreply, socket}
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

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
