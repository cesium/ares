defmodule AresWeb.AppLive.Profile do
  use AresWeb, :live_view

  alias Ares.Teams

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

        <%= if @user.team do %>
          <div class="bg-gray rounded-lg p-8 border border-gray-800 font-inter">
            <h2 class="text-3xl font-vt323 uppercase">Member of</h2>

            <div class="mb-6 pb-6 border-b border-gray-800">
              <div class="flex flex-col md:flex-row md:items-start md:justify-between mb-4">
                <div class="mb-4 md:mb-0">
                  <h3 class="text-3xl font-resegrg mb-2">{@user.team.name}</h3>
                  <p class="text-lg text-white">{@user.team.description}</p>
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
                <p class="font-bold text-white text-lg">{Enum.count(@user.team.members)}/5</p>
              </div>
            </div>

            <div>
              <h4 class="text-2xl mb-4 font-vt323 uppercase">Team Members:</h4>
              <div class="space-y-3">
                <%= for member <- @user.team.members do %>
                  <div class="bg-gray-900 rounded-lg p-4">
                    <div class="flex flex-row justify-between items-center">
                      <div>
                        <p class="font-semibold text-white text-lg flex flex-row items-center gap-1">
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
          <div class="bg-gray rounded-lg p-8 border border-gray-800 text-center font-inter">
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

    {:ok, assign(socket, user: Map.put(user, :team, team))}
  end
end
