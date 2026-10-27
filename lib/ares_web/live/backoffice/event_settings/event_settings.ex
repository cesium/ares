defmodule AresWeb.BackofficeLive.EventSettings do
  use AresWeb, :backoffice_view

  on_mount {AresWeb.UserAuth, :require_authenticated}
  alias Ares.{Constants, Event}

  import AresWeb.CoreComponents

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket) do
    if user.is_admin do
      limit =
        case Constants.get("attendees_limit") do
          {:ok, value} -> value
          _ -> nil
        end

      registrations_open =
        case Constants.get("registrations_open") do
          {:ok, value} -> value
          _ -> "false"
        end

      {:ok,
       socket
       |> assign(:attendees_limit, limit)
       |> assign(:registrations_open, registrations_open)
       |> assign(:show_modal, false)}
    else
      {:ok, socket |> redirect(to: ~p"/app/profile")}
    end
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    limit =
      case Constants.get("attendees_limit") do
        {:ok, value} -> value
        _ -> nil
      end

    {:noreply,
     socket
     |> assign(:attendees_limit, limit)
     |> assign(:show_modal, false)}
  end

  @impl true
  def handle_event("open_modal", _params, socket) do
    {:noreply, assign(socket, :show_modal, true)}
  end

  @impl true
  def handle_event("close_modal", _params, socket) do
    {:noreply, assign(socket, :show_modal, false)}
  end

  @impl true
  def handle_event("toggle_registrations", _params, socket) do
    value =
      if socket.assigns.registrations_open == "true" do
        "false"
      else
        "true"
      end

    Event.change_registrations_open(value)

    {:noreply, assign(socket, :registrations_open, value)}
  end
end
