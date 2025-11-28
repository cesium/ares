defmodule AresWeb.App.AdminLive.Index do
  use AresWeb, :live_view

  alias Ares.Teams
  alias Ares.Users

  @impl true
  def mount(_params, session, socket) do
    user_id = session["user_id"]

    socket =
      socket
      |> assign(:page_title, "Admin Dashboard")

    case user_id && Users.get_user(user_id) do
      {:ok, user} ->
        if user.is_admin do
          teams = Teams.list_teams()

          {:ok,
           socket
           |> assign(:user, user)
           |> assign(:teams, teams)
           |> assign(:error, nil)}
        else
          {:ok,
           socket
           |> assign(:user, user)
           |> assign(:error, "You don't have admin permissions.")}
        end

      _ ->
        {:ok,
         socket
         |> assign(:user, nil)
         |> assign(:error, "You must be logged in to access the admin dashboard.")}
    end
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :csrf_token, Map.get(assigns, :csrf_token, ""))
    ~H"""
    <.navbar fixed={true} user={@user} csrf_token={@csrf_token} />

    <main class="min-h-screen bg-black text-white">
      <%= if @error do %>
        <div class="max-w-2xl mx-auto py-16 px-4">
          <div class="bg-red-900 bg-opacity-20 border border-red-500 rounded-lg p-8 text-center">
            <h1 class="text-2xl font-black text-red-400 mb-2">Access Denied</h1>
            <p class="text-gray-300 mb-6"><%= @error %></p>
            <a href="/" class="inline-block bg-primary text-black font-bold py-2 px-6 rounded-lg hover:bg-secondary transition-colors">
              Go Back Home
            </a>
          </div>
        </div>
      <% else %>
        <div class="max-w-6xl mx-auto py-16 px-4">
          <div class="mb-12">
            <h1 class="text-4xl font-black mb-2">Admin Dashboard</h1>
            <p class="text-gray-400">Manage all teams and participants</p>
          </div>

          <!-- Teams Grid -->
          <div class="space-y-8">
            <%= for team <- @teams do %>
              <div class="bg-gray-900 rounded-lg p-8 border border-gray-800">
                <div class="flex items-center justify-between mb-6">
                  <div>
                    <h2 class="text-3xl font-black mb-2"><%= team.name %></h2>
                    <p class="text-gray-400"><%= team.description %></p>
                  </div>
                  <div class="text-right">
                    <div class="bg-gray-800 rounded px-3 py-2 inline-block">
                      <span class="text-sm text-gray-300">Team Code: </span>
                      <span class="text-white font-bold"><%= team.code %></span>
                    </div>
                  </div>
                </div>

                <!-- Team Info -->
                <div class="grid grid-cols-3 gap-4 mb-6 pb-6 border-b border-gray-700">
                  <div>
                    <p class="text-sm text-gray-400 mb-1">Experience Level</p>
                    <p class="font-bold text-white capitalize"><%= team.experience_level %></p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-400 mb-1">Status</p>
                    <%= if team.looking_for_members do %>
                      <p class="font-bold text-green-400">Looking for members</p>
                    <% else %>
                      <p class="font-bold text-orange-400">Team Complete</p>
                    <% end %>
                  </div>
                  <div>
                    <p class="text-sm text-gray-400 mb-1">Skills Needed</p>
                    <p class="font-bold text-white"><%= team.skills_needed %></p>
                  </div>
                </div>

                <!-- Members -->
                <div>
                  <h3 class="text-xl font-bold mb-4 text-yellow-200">Team Members (<%= Enum.count(@teams |> Enum.find(&(&1.code == team.code)) |> Map.get(:members, [])) %>)</h3>
                  <div class="space-y-3">
                    <%= if Enum.empty?(team.members) do %>
                      <p class="text-sm text-gray-400">No members yet. Users can join by entering the team code during registration.</p>
                    <% else %>
                      <%= for member <- team.members do %>
                        <div class="bg-gray-800 rounded p-4 border-l-4 border-primary">
                          <div class="flex items-start justify-between">
                            <div>
                              <p class="font-bold text-white"><%= member.name %></p>
                              <p class="text-sm text-gray-400"><%= member.email %></p>
                              <p class="text-sm text-gray-500"><%= member.phone %></p>
                            </div>
                            <div class="text-right">
                              <p class="text-xs bg-gray-700 text-gray-300 px-2 py-1 rounded"><%= member.university %></p>
                            </div>
                          </div>
                        </div>
                      <% end %>
                    <% end %>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>
    </main>

    <.footer />
    """
  end
end
