defmodule AresWeb.Backoffice.ScheduleFormComponent do
  @moduledoc """
  Form component for creating and editing schedule activities.
  """
  use AresWeb, :live_component

  alias Ares.Schedule
  alias Ares.Schedule.Activity

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>
          {gettext("Activities are shown on the public schedule page.")}
        </:subtitle>
      </.header>

      <.form
        for={@form}
        id="activity-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        autocomplete="off"
        class="flex flex-col gap-8"
      >
        <div class="grid grid-cols-2 gap-5">
          <.input variant="dark" field={@form[:title]} type="text" label="Title" required />
          <.input
            variant="dark"
            field={@form[:type]}
            type="select"
            label="Type"
            required
            options={Enum.map(Activity.types(), &{String.capitalize(to_string(&1)), &1})}
          />
          <.input variant="dark" field={@form[:date]} type="date" label="Date" required />
          <.input variant="dark" field={@form[:time]} type="time" label="Time" required />
        </div>
        <.input variant="dark" field={@form[:description]} type="textarea" label="Description" />
        <.button
          variant="secondary"
          class="self-end"
          phx-disable-with="Saving..."
          text="Save Activity"
        />
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{activity: activity} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn -> to_form(Schedule.change_activity(activity)) end)}
  end

  @impl true
  def handle_event("validate", %{"activity" => params}, socket) do
    changeset = Schedule.change_activity(socket.assigns.activity, params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"activity" => params}, socket) do
    result =
      case socket.assigns.action do
        :new -> Schedule.create_activity(params)
        :edit -> Schedule.update_activity(socket.assigns.activity, params)
      end

    case result do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity saved successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
