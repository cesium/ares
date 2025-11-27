defmodule Ares.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :description, :text
      add :captain_name, :string, null: false
      add :captain_email, :string, null: false
      add :captain_phone, :string
      add :member1_name, :string
      add :member1_email, :string
      add :member2_name, :string
      add :member2_email, :string
      add :member3_name, :string
      add :member3_email, :string
      add :member4_name, :string
      add :member4_email, :string
      add :skills_needed, :text
      add :experience_level, :string
      add :looking_for_members, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    create index(:teams, [:captain_email])
    create index(:teams, [:name])
  end
end
