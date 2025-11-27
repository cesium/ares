defmodule Bugsbyte.Repo.Migrations.AddCodToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :code, :string
    end

    create index(:teams, [:code], unique: true)
  end
end
