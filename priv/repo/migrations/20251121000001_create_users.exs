defmodule Ares.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone, :string
      add :age, :string
      add :university, :string
      add :course, :string
      add :team_code, :string
      add :vegan, :boolean, default: false
      add :notes, :text
      add :cv_filename, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
