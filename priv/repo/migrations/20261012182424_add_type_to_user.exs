defmodule Ares.Repo.Migrations.AddTypeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :type, :string, null: false, default: "attendee"
    end

    execute "UPDATE users SET type = 'admin' WHERE is_admin", ""
  end
end
