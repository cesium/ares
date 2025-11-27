defmodule Bugsbyte.Repo.Migrations.PopulateTeamCodes do
  use Ecto.Migration

  def up do
    execute("UPDATE teams SET code = 'TEAM001' WHERE id = 1;")
    execute("UPDATE teams SET code = 'TEAM002' WHERE id = 2;")
    execute("UPDATE teams SET code = 'TEAM003' WHERE id = 3;")
    execute("UPDATE teams SET code = 'TEAM004' WHERE id = 4;")
  end

  def down do
    execute("UPDATE teams SET code = NULL;")
  end
end
