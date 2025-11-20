defmodule Bugsbyte.CVUpload do
  @moduledoc """
  Attendee Curriculum Vitae upload component.
  """
  use Phoenix.LiveComponent
  use Phoenix.Component
  use Gettext, backend: BugsbyteWeb.Gettext

  attr :in_app, :boolean, default: false

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <p>CV Upload component placeholder</p>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket |> assign(:uploaded_files, [])}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end
end
