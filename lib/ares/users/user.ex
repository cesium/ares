defmodule Ares.Users.User do
  @moduledoc """
  User schema for event participants.
  """
  use Ares.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :age, :string
    field :university, :string
    field :course, :string
    field :team_code, :string
    field :vegan, :boolean, default: false
    field :notes, :string
    field :cv, Uploaders.CV.Type
    field :is_admin, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [
      :name,
      :email,
      :phone,
      :age,
      :university,
      :course,
      :team_code,
      :vegan,
      :notes,
      :cv,
      :is_admin,
      :password
    ])
    |> validate_required([:name, :email])
    |> validate_email(opts)
    |> validate_length(:name, min: 2, max: 100)
    |> unique_constraint(:email)
    |> hash_password_if_present()
  end

  @doc """
  Changeset for user registration (requires password).
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :email,
      :phone,
      :age,
      :university,
      :course,
      :team_code,
      :vegan,
      :notes,
      :cv,
      :password
    ])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
      message: "deve ter um formato de email válido"
    )
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:password, min: 6, message: "deve ter pelo menos 6 caracteres")
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  defp hash_password_if_present(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Ares.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  Verifies the password matches the stored hash.
  """
  def verify_password(password, password_hash) do
    Bcrypt.verify_pass(password, password_hash)
  rescue
    _ -> false
  end

  def cv_changeset(user, attrs) do
    user
    |> cast_attachments(attrs, [:cv])
  end
end
