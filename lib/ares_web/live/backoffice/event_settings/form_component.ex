defmodule AresWeb.BackofficeLive.EventSettingsFormComponent do
  use AresWeb, :live_component
  alias Ares.Event

  import AresWeb.CoreComponents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <form for={:attendees_limit_form} phx-target={@myself} phx-submit="save">
        <input
          label="Attendees Limit"
          name="limit"
          type="number"
          value={@attendees_limit}
          min="1"
          required
        />
        <.button type="submit">Save</.button>
      </form>
    </div>
    """
  end

 @impl true
  def handle_event("save", %{"limit" => limit_str}, socket) do
    case Integer.parse(limit_str) do
      {limit, ""} when limit > 0 ->
        Event.change_attendees_limit(limit)
        {:noreply,
         socket
         |> put_flash(:info, "Limit updated")
         |> push_patch(to: "/backoffice/event_settings")}
      _ ->
        {:noreply, socket |> put_flash(:error, "Invalid limit")}
    end
  end
end
