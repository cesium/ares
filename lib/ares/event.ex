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
    case get_attendees_limit() do
      nil -> false
      limit -> current_attendees > limit
    end
  end

  @doc """
  Returns the attendees limit, or `nil` if none is set.

  ## Examples

      iex> get_attendees_limit()
      100
  """
  def get_attendees_limit do
    case Constants.get("attendees_limit") do
      {:ok, limit} -> String.to_integer(limit)
      _ -> nil
    end
  end

  @doc """
  Returns whether registrations were opened in the backoffice,
  regardless of the attendees limit. See `registrations_open?/1`.
  """
  def registrations_enabled? do
    Constants.get("registrations_open") == {:ok, "true"}
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

    registrations_enabled?() and not attendees_limit_reached?(attendee_count)
  end
end
