defmodule Bugsbyte.Teams.Team do
  @moduledoc """
  Team schema for team formation.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :description, :string
    field :captain_name, :string
    field :captain_email, :string
    field :captain_phone, :string
    field :member1_name, :string
    field :member1_email, :string
    field :member2_name, :string
    field :member2_email, :string
    field :member3_name, :string
    field :member3_email, :string
    field :member4_name, :string
    field :member4_email, :string
    field :skills_needed, :string
    field :experience_level, :string
    field :looking_for_members, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :name, :description, :captain_name, :captain_email, :captain_phone,
      :member1_name, :member1_email, :member2_name, :member2_email,
      :member3_name, :member3_email, :member4_name, :member4_email,
      :skills_needed, :experience_level, :looking_for_members
    ])
    |> validate_required([:name, :captain_name, :captain_email])
    |> validate_format(:captain_email, ~r/^[^\s]+@[^\s]+$/, message: "deve ter um formato de email válido")
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:captain_name, min: 2, max: 100)
    |> validate_length(:description, max: 500)
  end
end
