defmodule Ares.Accounts.UserNotifier do
  @moduledoc """
  Module responsible for sending account-related emails to users.
  """
  import Swoosh.Email

  alias Ares.Accounts.User
  alias Ares.Mailer
  alias Ares.Teams.Team

  use Phoenix.Swoosh, view: AresWeb.EmailView

  defp base_html_email(recipient, subject) do
    sender = {Mailer.get_sender_name(), Mailer.get_sender_address()}

    phx_host =
      if System.get_env("PHX_HOST") != nil do
        "https://" <> System.get_env("PHX_HOST")
      else
        ""
      end

    new()
    |> to(recipient)
    |> from(sender)
    |> subject("[#{elem(sender, 0)}] #{subject}")
    |> assign(:phx_host, phx_host)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    email =
      base_html_email(user.email, "Update your email address")
      |> assign(:user_name, user.name)
      |> assign(:confirm_email_link, url)
      |> render_body("confirm_email.html")

    case Mailer.deliver(email) do
      {:ok, _metadata} -> {:ok, email}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Deliver instructions to log in with a magic link.
  """
  def deliver_login_instructions(user, url) do
    case user do
      %User{confirmed_at: nil} -> deliver_confirmation_instructions(user, url)
      _ -> deliver_magic_link_instructions(user, url)
    end
  end

  defp deliver_magic_link_instructions(user, url) do
    email =
      base_html_email(user.email, "Log in to your account")
      |> assign(:user_name, user.name)
      |> assign(:magic_link, url)
      |> render_body("magic_link.html")

    case Mailer.deliver(email) do
      {:ok, _metadata} -> {:ok, email}
      {:error, reason} -> {:error, reason}
    end
  end

  defp deliver_confirmation_instructions(user, url) do
    email =
      base_html_email(user.email, "Confirm your email")
      |> assign(:user_name, user.name)
      |> assign(:confirm_email_link, url)
      |> render_body("confirm_email.html")

    case Mailer.deliver(email) do
      {:ok, _metadata} -> {:ok, email}
      {:error, reason} -> {:error, reason}
    end
  end

  def deliver_team_reminder(%User{} = user) do
    email =
      base_html_email(user.email, "Reminder to join a team!")
      |> assign(:user_name, user.name)
      |> render_body("team_reminder_email.html")

    case Mailer.deliver(email) do
      {:ok, _metadata} -> {:ok, email}
      {:error, reason} -> {:error, reason}
    end
  end

  def deliver_team_payment_reminder(%Team{} = team) do
    email =
      base_html_email(team.leader.email, "Payment Reminder")
      |> assign(:user_name, team.leader.name)
      |> render_body("payment_reminder_email.html")

    case Mailer.deliver(email) do
      {:ok, _metadata} -> {:ok, email}
      {:error, reason} -> {:error, reason}
    end
  end
end
