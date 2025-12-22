defmodule Ares.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :code, :string
      add :skills_needed, :string
      add :experience_level, :string
      add :public, :boolean, default: false, null: false
      add :paid, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
