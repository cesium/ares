defmodule AresWeb.Components.CVUploader do
  @moduledoc """
  Component for uploading CVs.
  """
  use AresWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="my-8 w-full">
      <.live_file_input upload={@uploaders.cv} class="hidden" />
      <div
        :if={length(@uploaders.cv.entries) == 0}
        class="group relative overflow-hidden rounded-sm border-2 bg-white"
        phx-drop-target={@uploaders.cv.ref}
      >
        <div class="px-4 py-6 text-center">
          <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-lg">
            <.icon
              name="hero-cloud-arrow-up"
              class="h-8 w-8 text-gray-400 transition-colors duration-200"
            />
          </div>
          <div class="mt-3">
            <label
              for="file-upload"
              class="cursor-pointer font-semibold text-primary hover:text-primary/80 transition-colors"
            >
              <a onclick={"document.getElementById('#{@uploaders.cv.ref}').click()"}>
                <span>Upload CV</span>
              </a>
            </label>
            <span class="text-sm text-gray-600"> or drag and drop</span>
          </div>
          <p class="mt-1 text-xs text-gray-500">
            PDF, DOC, DOCX, TXT, MD, RTF (max 10MB)
          </p>
        </div>
      </div>
      <div class="mt-3 space-y-2">
        <%= for entry <- @uploaders.cv.entries do %>
          <%= for err <- upload_errors(@uploaders.cv, entry) do %>
            <div class="rounded-sm border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800">
              <div class="flex items-center gap-2">
                <.icon name="hero-exclamation-circle" class="h-4 w-4 flex-shrink-0" />
                <span>{Phoenix.Naming.humanize(err)}</span>
              </div>
            </div>
          <% end %>
          <div class="animate-in fade-in slide-in-from-top-2 duration-300">
            <div class="rounded-sm border border-gray-200 bg-white shadow-sm">
              <div class="flex items-center gap-3 p-3">
                <div class="min-w-0 flex-1">
                  <p class="truncate text-sm font-medium text-gray-900">
                    <%= if String.length(entry.client_name) < 40 do %>
                      {entry.client_name}
                    <% else %>
                      {String.slice(entry.client_name, 0..36) <> "..."}
                    <% end %>
                  </p>
                  <div class="mt-1.5">
                    <div class="h-1 w-full overflow-hidden rounded-full bg-gray-200">
                      <div
                        class="h-full rounded-full bg-primary transition-all duration-300"
                        style={"width: #{entry.progress}%"}
                      >
                      </div>
                    </div>
                    <p class="mt-0.5 text-xs text-gray-500">
                      {entry.progress}%
                    </p>
                  </div>
                </div>
                <button
                  type="button"
                  phx-click="cancel-upload"
                  phx-value-ref={entry.ref}
                  aria-label="Remove file"
                  class="flex-shrink-0 rounded-sm p-1.5 text-gray-400 transition-colors hover:bg-red-50 hover:text-red-600"
                >
                  <.icon name="hero-x-mark" class="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
