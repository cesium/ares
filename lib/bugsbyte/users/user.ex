defmodule Bugsbyte.Users.User do
  @moduledoc """
  User schema for event participants.
  """
  use Ecto.Schema
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
    field :cv_filename, :string
    field :is_admin, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
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
      :cv_filename,
      :is_admin
    ])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
      message: "deve ter um formato de email válido"
    )
    |> validate_length(:name, min: 2, max: 100)
    |> unique_constraint(:email)
  end
end
