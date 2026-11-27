defmodule Ares.Event do
  @moduledoc """
  The event context.
  """
  use Ares.Context

  alias Ares.Constants

  @doc """
  Returns whether the attendees limit was reached.

  ## Examples

      iex> attendees_limit_reached?()
      false
  """
  def attendees_limit_reached?(current_attendees) do
    case Constants.get("attendees_limit") do
      {:ok, limit_str} ->
        limit = String.to_integer(limit_str)
        current_attendees > limit

      _ ->
        false
    end
  end

  @doc """
  Changes the attendees limit for the event.

  ## Examples

      iex> change_attendees_limit(100)
      :ok
  """
  def change_attendees_limit(limit) when is_integer(limit) and limit > 0 do
    Constants.set("attendees_limit", Integer.to_string(limit))
  end

  @doc """
  Changes the registrations_open constant.

  ## Examples

      iex> change_registrations_open("true")
      :ok
  """
  def change_registrations_open(value) do
    Constants.set("registrations_open", value)
  end

  @doc """
  Returns whether registrations are open.
  """
  def registrations_open?(current_attendees \\ nil) do
    attendee_count =
      case current_attendees do
        nil -> Ares.Accounts.count_attendees_with_team()
        count -> count
      end

    case Constants.get("registrations_open") do
      {:ok, "true"} -> not attendees_limit_reached?(attendee_count)
      _ -> false
    end
  end
end
