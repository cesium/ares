defmodule Ares.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :repo_url, :string
      add :demo_url, :string
      add :submitted_at, :utc_datetime
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:projects, [:team_id])
  end
end
