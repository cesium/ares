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
        current_attendees >= limit

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
  end
