defmodule AresWeb.BackofficeLive.EventSettings do
  use AresWeb, :live_view
  alias Ares.Constants

  import AresWeb.CoreComponents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="flex items-center gap-4">
        <h2>Attendees Limit: <%= @attendees_limit || "Not set" %></h2>
        <.button phx-click="open_modal"><.icon name="hero-pencil" /></.button>
      </div>

      <.modal :if={@show_modal} id="attendees-limit-modal" show on_cancel={JS.push("close_modal")}>
        <.live_component
          module={AresWeb.BackofficeLive.EventSettingsFormComponent}
          id="attendees-limit-form"
          attendees_limit={@attendees_limit}
        />
      </.modal>
    </div>
    """
  end
  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket) do
    if user.is_admin do
      limit =
        case Constants.get("attendees_limit") do
          {:ok, value} -> value
          _ -> nil
        end

        {:ok,
        socket
        |> assign(:attendees_limit, limit)
        |> assign(:show_modal, false)}
    else
        {:ok,
        socket
        |> redirect(to: ~p"/app/profile")}
    end
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    limit =
      case Constants.get("attendees_limit") do
        {:ok, value} -> value
        _ -> nil
      end

    {:noreply, socket
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
end
