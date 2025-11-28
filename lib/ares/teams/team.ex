defmodule Ares.Teams.Team do
  @moduledoc """
  Team schema for team formation.
  """
  use Ares.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :description, :string
    field :code, :string
    field :skills_needed, :string
    field :experience_level, :string
    field :looking_for_members, :boolean, default: false

    has_many :members, Ares.Users.User, foreign_key: :team_code, references: :code

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :name,
      :description,
      :code,
      :skills_needed,
      :experience_level,
      :looking_for_members
    ])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:description, max: 500)
  end
end
