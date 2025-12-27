defmodule Ares.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, :string
      add :amount, :decimal
      add :status, :string
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:payments, [:team_id])
  end
end
