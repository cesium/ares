defmodule AresWeb.AppLive.Profile do
  use AresWeb, :live_view

  alias Ares.Accounts
  alias Ares.Accounts.User
  alias Ares.Teams
  alias AresWeb.Components.CVUploader

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-5xl mx-auto">
        <div class="text-center mb-12">
          <div class="w-32 h-32 rounded-full bg-gradient-to-bl from-primary to-darkest-pink mx-auto mb-6 flex items-center justify-center shadow-2xl">
            <span class="text-6xl font-bold">
              {String.first(@user.name)}
            </span>
          </div>
          <h1 class="text-4xl sm:text-6xl font-extrabold tracking-tight mb-2">{@user.name}</h1>
          <p class="text-2xl text-gray-300">{@user.email}</p>
        </div>

        <%= if @user.team && @user.team.leader_id == @user.id && length(@user.team.members) >= 2 do %>
          <div
            :if={@user.team.payment_status in [:none, :started]}
            class="mb-8 p-4 bg-green-900 border border-green-700 rounded-lg text-green-100 flex flex-row items-center justify-center gap-4 font-inter"
          >
            <.icon name="hero-banknotes" class="w-12 text-green-300" />
            <span class="text-sm">
              As the team leader, you may proceed to payment <b>only once your team is fully assembled</b>. Complete the payment for your team <.link
                patch={~p"/app/payment"}
                class="underline font-bold"
              >here</.link>.
              Teams that do not complete payment by the deadline will lose their spot.
            </span>
          </div>
        <% end %>

        <%= if @user.team do %>
          <div class="bg-gray rounded-lg p-8 border border-gray-800 font-inter mb-8">
            <h2 class="text-3xl font-vt323 uppercase">Member of</h2>

            <div class="mb-6 pb-6 border-b border-gray-800">
              <div class="flex flex-col md:flex-row md:items-start md:justify-between mb-4">
                <div class="mb-4 md:mb-0">
                  <h3 class="text-3xl font-resegrg mb-2">{@user.team.name}</h3>
                  <p class="text-lg text-white">{@user.team.description}</p>
                </div>
                <div :if={@user.team.payment_status == :paid}>
                  <div class="font-inter text-green-400 flex flex-row items-center gap-2 text-xl">
                    <.icon name="hero-check-circle" class="w-6 h-6" />
                    <span class="font-bold">
                      {String.capitalize(to_string(@user.team.payment_status))}
                    </span>
                  </div>
                </div>
              </div>

              <div class="bg-gray-900 rounded px-4 py-2 inline-block text-xl font-vt323">
                <span class="text-gray-300 uppercase">Team Code: </span>
                <span class="text-white">{@user.team.code}</span>
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              <div>
                <p class="text-sm text-gray-400 mb-1">Experience Level</p>
                <p class="font-bold text-white capitalize text-lg">{@user.team.experience_level}</p>
              </div>
              <div>
                <p class="text-sm text-gray-400 mb-1">Members</p>
                <p class="font-bold text-white text-lg flex flex-row gap-4">
                  {length(@user.team.members)}/5
                  <span
                    :if={length(@user.team.members) < 2}
                    class="text-xs flex flex-row items-center gap-2"
                  >
                    <.icon name="hero-exclamation-triangle" class="w-8" />
                    For your team to be valid, 2 or more members are required.
                  </span>
                </p>
              </div>
            </div>

            <div>
              <h4 class="text-2xl mb-4 font-vt323 uppercase">Team Members:</h4>
              <div class="space-y-3">
                <%= for member <- @user.team.members do %>
                  <div class="bg-gray-900 rounded-lg p-4">
                    <div class="flex flex-row justify-between items-center">
                      <div>
                        <p class="font-semibold text-white text-lg flex flex-row items-center gap-2">
                          {first_last_name(member.name)}
                          <.icon :if={@user.team.leader_id == member.id} name="hero-star" />
                        </p>
                        <p class="text-gray-400">{member.email}</p>
                      </div>
                      <%= if member.id == @user.id do %>
                        <span class="bg-primary text-black text-xl font-bold px-3 py-1 rounded font-vt323 uppercase">
                          You!
                        </span>
                      <% end %>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        <% else %>
          <div
            :if={!@user.is_admin}
            class="bg-gray rounded-lg p-8 border border-gray-800 text-center font-inter"
          >
            <div class="py-8">
              <.icon name="hero-users" class="w-16 h-16 mx-auto mb-4 text-gray-600" />
              <p class="text-lg text-gray-400 mb-6">
                To participate in the event, you need to join or create a team.
              </p>
              <.button navigate={~p"/app/team-formation"} class="btn btn-primary">
                <.icon name="hero-arrow-right" class="w-5 h-5 mr-2" /> Go to Team Formation
              </.button>
            </div>
          </div>
        <% end %>

        <div class="bg-gray rounded-lg p-8 border border-gray-800 font-inter">
          <h2 class="text-3xl font-vt323 uppercase">Upload your CV</h2>
          <%= if @user.cv do %>
            <div class="flex items-center gap-4 mt-2">
              <p class="text-sm text-gray-400">Current: {@user.cv.file_name}</p>
              <button
                type="button"
                class="text-sm text-primary underline cursor-pointer"
                phx-click="remove-cv"
                onclick="return confirm('Remove current CV?');"
              >
                Remove
              </button>
            </div>
          <% end %>

          <.form
            for={@form}
            id="profile_info_form"
            phx-submit="save"
            phx-change="validate"
            class="font-inter mt-8"
          >
            <.live_component
              module={CVUploader}
              id="cv-uploader"
              uploaders={@uploads}
            />

            <.button
              phx-disable-with="Saving..."
              class="btn btn-primary w-full mt-6"
              disabled={@cv_uploading || @cv_upload_error}
            >
              Save
            </.button>

            <%= if @cv_upload_error do %>
              <p class="text-sm text-primary mt-2">
                There was a problem with the uploaded CV. Please remove and re-upload or try a different file.
              </p>
            <% end %>
          </.form>
        </div>
      </div>
    </Layouts.app>
    """
  end

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
