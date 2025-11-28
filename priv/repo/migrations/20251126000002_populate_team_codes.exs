defmodule Ares.Repo.Migrations.PopulateTeamCodes do
  use Ecto.Migration

  def up do
    execute("UPDATE teams SET code = 'TEAM001' WHERE name = 'Bug Hunters';")
    execute("UPDATE teams SET code = 'TEAM002' WHERE name = 'Data Ninjas';")
    execute("UPDATE teams SET code = 'TEAM003' WHERE name = 'Code Masters';")
    execute("UPDATE teams SET code = 'TEAM004' WHERE name = 'Web Wizards';")
  end

  def down do
    execute("UPDATE teams SET code = NULL;")
  end
end
