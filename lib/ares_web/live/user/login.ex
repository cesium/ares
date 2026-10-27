defmodule AresWeb.UserLive.Login do
  use AresWeb, :app_view

  alias Ares.{Accounts, Event}

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")
    attendee_count = Accounts.count_attendees_with_team()

    {:ok,
     socket |> assign(form: form, trigger_submit: false) |> assign(attendee_count: attendee_count)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/log-in/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:ares, Ares.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
