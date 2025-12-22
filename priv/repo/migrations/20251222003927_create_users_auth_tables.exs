defmodule Ares.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :email, :citext, null: false
      add :phone, :string
      add :age, :integer
      add :course, :string
      add :university, :string
      add :notes, :text
      add :is_admin, :boolean, default: false
      add :hashed_password, :string
      add :confirmed_at, :utc_datetime
      add :team_id, references(:teams, type: :binary_id, on_delete: :nilify_all), null: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])

    create table(:users_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :authenticated_at, :utc_datetime

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

    alter table(:teams) do
      add :leader_id, references(:users, type: :binary_id, on_delete: :nilify_all), null: false
    end
  end
end
