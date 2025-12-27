defmodule AresWeb.AppLive.TeamFormation do
  use AresWeb, :live_view

  alias Ares.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-4xl space-y-4">
        <div class="flex flex-col gap-2 mb-8">
          <h1 class="font-resegrg px-1 sm:px-2 text-4xl sm:text-5xl md:text-6xl">Team Formation</h1>
          <p class="text-xl md:text-2xl">
            Create your dream team or join forces with other participants!
          </p>
        </div>

        <div class="flex justify-center mt-6 mb-6 font-inter">
          <nav class="flex items-center space-x-8" role="tablist" aria-label="Team tabs">
            <.link
              navigate="?tab=create"
              class={"text-md pb-2 " <> (if @tab == "create", do: "text-primary border-b-2 border-primary", else: "text-gray-400 hover:text-gray-200")}
              aria-selected={@tab == "create"}
            >
              Create a team
            </.link>
            <.link
              navigate="?tab=join"
              class={"text-md pb-2 " <> (if @tab in ["join", "code"], do: "text-primary border-b-2 border-primary", else: "text-gray-400 hover:text-gray-200")}
              aria-selected={@tab in ["join", "code"]}
            >
              Join a team
            </.link>
          </nav>
        </div>

        <%= if @tab == "create" do %>
          <div class="bg-gray rounded-lg p-8 border border-gray-800 mb-12">
            <div class="mb-8">
              <h2 class="text-3xl font-resegrg mb-2">Create Your Team</h2>
              <p class="text-xl text-gray-400">Fill in the details to create a new team</p>
            </div>

            <.form
              for={@form}
              phx-submit="save"
              phx-change="validate"
              class="space-y-8 font-inter"
            >
              <div class="space-y-6">
                <div>
                  <.input
                    field={@form[:name]}
                    type="text"
                    label="Name"
                    placeholder="e.g. Code Ninjas, Bug Hunters..."
                    required
                  />
                </div>

                <div>
                  <.input
                    field={@form[:description]}
                    type="textarea"
                    label="Description"
                    placeholder="Describe your team's goals, what you want to achieve, and what makes your team unique..."
                    rows="4"
                  />
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <.input
                      field={@form[:experience_level]}
                      type="select"
                      label="Team Experience Level"
                      options={[
                        {"Beginner - New to hackathons", "beginner"},
                        {"Intermediate - Some experience", "intermediate"},
                        {"Advanced - Experienced hackers", "advanced"},
                        {"Mixed - Various skill levels", "mixed"}
                      ]}
                    />
                  </div>

                  <div>
                    <.input
                      field={@form[:skills_needed]}
                      type="text"
                      label="Skills Needed (Optional)"
                      placeholder="e.g., Frontend, Backend, Design..."
                    />
                  </div>
                </div>

                <div class="rounded-lg p-6 border border-gray-800">
                  <div class="flex items-start gap-4">
                    <.input
                      field={@form[:public]}
                      type="checkbox"
                    />
                    <div class="flex-1">
                      <label class="text-white font-bold text-lg cursor-pointer">
                        Looking for team members?
                      </label>
                      <p class="text-sm text-gray-400 mt-1">
                        Enable this if you want your team to be visible to other participants who are looking to join a team.
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              <div class="flex justify-center pt-4">
                <.button class="btn btn-primary w-full">
                  <.icon name="hero-user-group" class="w-5 h-5 mr-2" /> Create Team
                </.button>
              </div>
            </.form>
          </div>
        <% end %>
        <%= if @tab == "join" do %>
          <div class="mb-12">
            <div class="mb-8 flex flex-col sm:flex-row gap-6 justify-between items-center">
              <div>
                <h2 class="text-3xl font-resegrg mb-2">Join a Team</h2>
                <p class="text-xl text-gray-400">
                  Browse available teams and find your perfect match
                </p>
              </div>
              <.button phx-click="use-code" class="btn btn-primary w-full sm:w-auto text-xl uppercase">
                <.icon name="hero-key" class="w-5 h-5 mr-2" /> Use code
              </.button>
            </div>

            <%= if Enum.empty?(@available_teams) do %>
              <div class="bg-gray rounded-lg p-12 text-center border border-gray-800 font-inter">
                <.icon name="hero-user-group" class="w-16 h-16 mx-auto mb-4 text-gray-600" />
                <p class="text-gray-400 text-lg mb-6">
                  There are currently no teams looking for members.
                </p>
                <a
                  href="?tab=create"
                  class="inline-block bg-primary text-white font-bold py-3 px-6 rounded-lg hover:bg-primary/50 transition-colors cursor-pointer"
                >
                  Create Your Own Team
                </a>
              </div>
            <% else %>
              <div class="space-y-6">
                <%= for team <- @available_teams do %>
                  <div class="bg-gray rounded-lg p-6 border border-gray-800 transition-colors">
                    <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-6">
                      <div class="flex-1">
                        <div class="mb-4">
                          <h3 class="text-2xl font-resegrg mb-2">{team.name}</h3>
                          <p class="text-gray-300 text-lg">{team.description}</p>
                        </div>

                        <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mb-4">
                          <div class="rounded-lg p-3 border border-gray-800">
                            <p class="text-sm text-gray-400 mb-1">Experience</p>
                            <p class="text-white font-bold capitalize">{team.experience_level}</p>
                          </div>
                          <div class="rounded-lg p-3 border border-gray-800">
                            <p class="text-sm text-gray-400 mb-1">Members</p>
                            <p class="text-white font-bold">
                              {length(team.members)}/5
                            </p>
                          </div>
                          <%= if team.skills_needed && team.skills_needed != "" do %>
                            <div class="rounded-lg p-3 border border-gray-800 col-span-2 md:col-span-1">
                              <p class="text-sm text-gray-400 mb-1">Skills Needed</p>
                              <p class="text-white font-bold">{team.skills_needed}</p>
                            </div>
                          <% end %>
                        </div>

                        <div class="flex items-center gap-2">
                          <.icon name="hero-users" class="w-5 h-5 text-primary" />
                          <span class="text-sm text-gray-400">
                            {5 - length(team.members)} spot{if 5 - length(team.members) != 1, do: "s"} available
                          </span>
                        </div>
                      </div>

                      <div class="flex items-center font-inter">
                        <.button
                          phx-click="join-team"
                          class="btn btn-primary flex items-center"
                          phx-value-team_code={team.code}
                          data-confirm={"Are you sure you want to join #{team.name}?"}
                        >
                          <.icon name="hero-user-plus" class="w-5 h-5 mr-2" /> Join
                        </.button>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        <% end %>
        <%= if @tab == "code" do %>
          <div class="mb-12">
            <div class="mb-4 flex flex-row justify-between items-center">
              <div>
                <h2 class="text-3xl font-resegrg mb-2">Join a Team</h2>
                <p class="text-xl text-gray-400">Join via code</p>
              </div>
            </div>
            <.form
              for={@code_form}
              phx-submit="submit_code"
              class="space-y-8 font-inter"
            >
              <div class="flex flex-row justify-between gap-4 items-center">
                <div class="w-full pb-2">
                  <.input
                    field={@code_form[:code]}
                    type="text"
                    label=""
                    placeholder="Enter the team code"
                    required
                  />
                </div>
                <div>
                  <.button class="btn btn-primary w-full">
                    Join
                  </.button>
                </div>
              </div>
            </.form>
          </div>
        <% end %>
        <div class="bg-gray rounded-lg p-8 border border-gray-800">
          <div class="flex items-center gap-3 mb-6">
            <.icon name="hero-information-circle" class="w-8 h-8 text-primary" />
            <h3 class="text-2xl uppercase">Important Information</h3>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 font-inter text-sm">
            <div class="flex items-start gap-4">
              <div class="shrink-0 w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
                <.icon name="hero-users" class="w-5 h-5 text-white" />
              </div>
              <div>
                <h4 class="font-bold text-white text-lg mb-1">Team Size</h4>
                <p class="text-gray-400">Teams can have between 2 to 5 members</p>
              </div>
            </div>

            <div class="flex items-start gap-4">
              <div class="shrink-0 w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
                <.icon name="hero-clipboard-document-check" class="w-5 h-5 text-white" />
              </div>
              <div>
                <h4 class="font-bold text-white text-lg mb-1">Registration</h4>
                <p class="text-gray-400">
                  You can register your team even without all members confirmed
                </p>
              </div>
            </div>

            <div class="flex items-start gap-4">
              <div class="shrink-0 w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
                <.icon name="hero-magnifying-glass" class="w-5 h-5 text-white" />
              </div>
              <div>
                <h4 class="font-bold text-white text-lg mb-1">Finding Members</h4>
                <p class="text-gray-400">
                  Select "Looking for members" if you want your team to be publicly visible to other participants
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: %{is_admin: true}}}} = socket) do
    {:ok,
     socket
     |> put_flash(:error, "Admins cannot join teams.")
     |> redirect(to: ~p"/app/profile")}
  end

  @impl true
  def mount(
        _params,
        _session,
        %{assigns: %{current_scope: %{user: %{team_id: team_id}}}} = socket
      )
      when not is_nil(team_id) do
    {:ok,
     socket
     |> put_flash(:error, "You are already in a team.")
     |> redirect(to: ~p"/app/profile")}
  end

  @impl true
  def mount(params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    tab = Map.get(params, "tab", "create")
    available_teams = Teams.list_available_teams()

    {:ok,
     socket
     |> assign(user: user, tab: tab)
     |> assign(available_teams: available_teams)
     |> assign_form(Teams.change_team(%Teams.Team{}, %{}))}
  end

  @impl true
  def handle_event("save", %{"team" => team_params}, socket) do
    case Teams.create_and_join_team(socket.assigns.user, team_params) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team created successfully!")
         |> push_navigate(to: ~p"/app/profile")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  @impl true
  def handle_event("use-code", _params, socket) do
    {:noreply,
     socket
     |> assign(:code_form, to_form(%{"code" => ""}, as: "team_code"))
     |> assign(:tab, "code")}
  end

  @impl true
  def handle_event("submit_code", %{"team_code" => %{"code" => code}}, socket) do
    case Teams.add_user_to_team_by_code(socket.assigns.user, code) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Successfully joined the team!")
         |> push_navigate(to: ~p"/app/profile")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to join team. " <> team_join_error(reason))
         |> assign(:tab, "code")}
    end
  end

  @impl true
  def handle_event("join-team", %{"team_code" => team_code}, socket) do
    case Teams.add_user_to_team_by_code(socket.assigns.user, team_code) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Successfully joined the team!")
         |> push_navigate(to: ~p"/app/profile")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to join team. " <> team_join_error(reason))}
    end
  end

  @impl true
  def handle_event("validate", %{"team" => team_params}, socket) do
    changeset = Teams.change_team(%Teams.Team{}, team_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "team")
    assign(socket, form: form)
  end

  defp team_join_error(:not_found), do: "Team not found."
  defp team_join_error(:unavailable), do: "This team is not accepting new members."
end
