defmodule Ares.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :description, :text
      add :type, :string, null: false
      add :date, :date, null: false
      add :time, :time, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:activities, [:date])
  end
end
