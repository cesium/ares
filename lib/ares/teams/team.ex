defmodule Ares.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teams" do
    field :name, :string
    field :description, :string
    field :code, :string
    field :skills_needed, :string
    field :experience_level, :string
    field :public, :boolean, default: false
    field :paid, :boolean, default: false

    has_many :members, Ares.Accounts.User, foreign_key: :team_id
    belongs_to :leader, Ares.Accounts.User, foreign_key: :leader_id, type: :binary_id

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
      :public,
      :paid,
      :leader_id
    ])
    |> validate_required([
      :name,
      :description,
      :code,
      :skills_needed,
      :experience_level,
      :public,
      :paid,
      :leader_id
    ])
  end

  def registration_changeset(team, attrs) do
    team
    |> cast(attrs, [
      :name,
      :description,
      :code,
      :skills_needed,
      :experience_level,
      :public,
      :leader_id
    ])
    |> validate_required([:name, :code, :leader_id])
  end
end
