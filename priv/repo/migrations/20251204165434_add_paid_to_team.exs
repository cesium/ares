defmodule Ares.Repo.Migrations.AddPaidToTeam do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :paid, :boolean, default: false
    end
  end
end
