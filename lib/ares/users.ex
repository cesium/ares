defmodule Ares.Users do
  @moduledoc """
  Context for managing users.
  """

  import Ecto.Query, warn: false
  alias Ares.Repo
  alias Ares.Users.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> validate_not_admin_joining_team()
    |> Repo.insert()
  end

  defp validate_not_admin_joining_team(changeset) do
    # Check if user is admin and trying to join a team
    case Ecto.Changeset.get_field(changeset, :is_admin) do
      true ->
        case Ecto.Changeset.get_field(changeset, :team_code) do
          nil -> changeset
          "" -> changeset
          _ -> Ecto.Changeset.add_error(changeset, :team_code, "Admins cannot join teams")
        end

      false ->
        changeset

      nil ->
        changeset
    end
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      {:ok, user} ->
        if User.verify_password(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end

      {:error, _} ->
        {:error, :invalid_credentials}
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> validate_not_admin_joining_team()
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def list_users_by_team_code(team_code) do
    Repo.all(from u in User, where: u.team_code == ^team_code, order_by: u.inserted_at)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user profile (name, handle, password and email).
  Doesn't validate the uniqueness of the email.

  ## Examples

      iex> change_user_profile(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_profile(user, attrs \\ %{}) do
    user
    |> User.changeset(attrs, validate_email: false)
  end

  @doc """
  Updates a user's CV.

  ## Examples

      iex> update_user_cv(user, %{cv: cv})
      {:ok, %User{}}

      iex> update_user_cv(user, %{cv: bad_cv})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_cv(%User{} = user, attrs) do
    user
    |> User.cv_changeset(attrs)
    |> Repo.update()
  end
end
