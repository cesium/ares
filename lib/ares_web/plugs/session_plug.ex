defmodule AresWeb.SessionPlug do
  @moduledoc """
  Plug to handle invalid sessions after schema changes.
  Clears session if user_id cannot be found (e.g., due to migration from integer to UUID IDs).
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, "user_id") do
      nil ->
        conn

      user_id ->
        # Check if user exists with this ID
        case Ares.Users.get_user(user_id) do
          {:ok, _user} ->
            conn

          {:error, :not_found} ->
            # User not found, clear the session
            delete_session(conn, "user_id")
        end
    end
  rescue
    # Handle Ecto.Query.CastError from type mismatch (integer vs binary_id)
    Ecto.Query.CastError ->
      delete_session(conn, "user_id")
  end
end
