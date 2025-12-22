defmodule AresWeb.UserLive.Registration do
  use AresWeb, :live_view

  alias Ares.Accounts
  alias Ares.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-xl">
        <div class="flex flex-col gap-2 mb-8">
          <h1 class="font-resegrg text-5xl">
            Registration
          </h1>
          <p class="text-2xl">
            Already registered? <.link
              navigate={~p"/log-in"}
              class="font-semibold text-primary hover:underline"
              phx-no-format
            >Log in</.link> to your account now.
          </p>
        </div>

        <.form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          class="font-inter"
        >
          <.input
            field={@form[:name]}
            type="text"
            label="Full Name"
            autocomplete="name"
            placeholder="John Doe"
            required
            phx-mounted={JS.focus()}
          />
          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            autocomplete="username"
            placeholder="john.doe@example.com"
            required
          />
          <.input
            field={@form[:phone]}
            type="text"
            label="Phone"
            autocomplete="tel"
            placeholder="912345678"
            required
          />
          <.input
            field={@form[:age]}
            type="number"
            label="Age"
            placeholder="18+"
            required
          />
          <.input
            field={@form[:course]}
            type="text"
            label="Course"
            placeholder="Engenharia Informática"
            required
          />
          <.input
            field={@form[:university]}
            type="text"
            label="University"
            placeholder="Universidade do Minho"
            required
          />
          <.input
            field={@form[:notes]}
            type="textarea"
            label="Notes"
            placeholder="If you have any special needs, requests or dietary restrictions, please let us know."
          />
          <p class="flex flex-row">
            <.input
              name="consent"
              type="checkbox"
              value={false}
              label="I agree with the event regulations."
              required
            />
          </p>

          <.button phx-disable-with="Creating account..." class="btn btn-primary w-full mt-6">
            Submit
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: AresWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "An email was sent to #{user.email}, please access it to confirm your account."
         )
         |> push_navigate(to: ~p"/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
