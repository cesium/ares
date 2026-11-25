defmodule AresWeb.BackofficeLive.Schedule do
  use AresWeb, :backoffice_view

  alias Ares.Schedule
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_activities(socket)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} = id |> Schedule.get_activity!() |> Schedule.delete_activity()

    {:noreply, assign_activities(socket)}
  end

  # The form component patches back to the index after saving, so refresh the list there.
  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activities")
    |> assign(:activity, nil)
    |> assign_activities()
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, Schedule.get_activity!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, %Schedule.Activity{})
  end

  defp assign_activities(socket) do
    assign(socket, :activities, Schedule.list_activities() |> Enum.map(&{&1.id, &1}))
  end
end
