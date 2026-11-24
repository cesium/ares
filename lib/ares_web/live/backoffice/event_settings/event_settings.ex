defmodule AresWeb.BackofficeLive.EventSettings do
  use AresWeb, :backoffice_view

  alias Ares.{Accounts, Event}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Event Settings")
     |> load_settings()}
  end

  @impl true
  def handle_event("toggle_registrations", _params, socket) do
    value = if socket.assigns.registrations_enabled, do: "false", else: "true"
    {:ok, _} = Event.change_registrations_open(value)

    {:noreply, load_settings(socket)}
  end

  def handle_event("validate_limit", %{"limit" => limit}, socket) do
    {:noreply, assign(socket, :limit_form, limit_form(limit))}
  end

  def handle_event("save_limit", %{"limit" => limit}, socket) do
    case parse_limit(limit) do
      {:ok, limit} ->
        {:ok, _} = Event.change_attendees_limit(limit)

        {:noreply,
         socket
         |> put_flash(:info, "Attendees limit updated.")
         |> load_settings()}

      :error ->
        {:noreply, assign(socket, :limit_form, limit_form(limit))}
    end
  end

  defp load_settings(socket) do
    with_team = Accounts.count_attendees_with_team()
    limit = Event.get_attendees_limit()

    socket
    |> assign(:attendees_limit, limit)
    |> assign(:with_team, with_team)
    |> assign(:with_paid_team, Accounts.count_attendees_with_paid_team())
    |> assign(:registrations_enabled, Event.registrations_enabled?())
    |> assign(:registrations_open, Event.registrations_open?(with_team))
    |> assign(:limit_form, limit_form(limit && Integer.to_string(limit)))
  end

  defp limit_form(limit) do
    errors =
      case limit do
        nil -> []
        _ -> if parse_limit(limit) == :error, do: [limit: {"must be a positive whole number", []}], else: []
      end

    to_form(%{"limit" => limit}, errors: errors)
  end

  defp parse_limit(limit) do
    case Integer.parse(limit) do
      {n, ""} when n > 0 -> {:ok, n}
      _ -> :error
    end
  end
end
