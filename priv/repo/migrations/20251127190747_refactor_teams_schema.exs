defmodule Ares.Repo.Migrations.RefactorTeamsSchema do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      remove :captain_name
      remove :captain_email
      remove :captain_phone
      remove :member1_name
      remove :member1_email
      remove :member2_name
      remove :member2_email
      remove :member3_name
      remove :member3_email
      remove :member4_name
      remove :member4_email
    end
  end
end
