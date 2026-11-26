defmodule Ares.ProjectsTest do
  use Ares.DataCase

  alias Ares.Projects

  describe "projects" do
    alias Ares.Projects.Project

    import Ares.ProjectsFixtures

    @invalid_attrs %{name: nil, description: nil, repo_url: nil, demo_url: nil, submitted_at: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert [listed] = Projects.list_projects()
      assert listed.id == project.id
      assert %Ares.Teams.Team{} = listed.team
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      team = Ares.TeamFixtures.team_fixture()
      valid_attrs = %{team_id: team.id, name: "some name", description: "some description", repo_url: "https://github.com", demo_url: "https://example.com", submitted_at: ~U[2026-11-21 17:45:00Z]}

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert project.team_id == team.id
      assert project.name == "some name"
      assert project.description == "some description"
      assert project.repo_url == "https://github.com"
      assert project.demo_url == "https://example.com"
      assert project.submitted_at == ~U[2026-11-21 17:45:00Z]
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", repo_url: "https://github.com/updated", demo_url: "https://updated.example.com", submitted_at: ~U[2026-11-22 17:45:00Z]}

      assert {:ok, %Project{} = project} = Projects.update_project(project, update_attrs)
      assert project.name == "some updated name"
      assert project.description == "some updated description"
      assert project.repo_url == "https://github.com/updated"
      assert project.demo_url == "https://updated.example.com"
      assert project.submitted_at == ~U[2026-11-22 17:45:00Z]
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end

    test "create_project/1 with invalid urls returns error changeset" do
      team = Ares.TeamsFixtures.team_fixture()
      assert {:error, changeset} =
        Projects.create_project(%{team_id: team.id, name: "some name", submitted_at: ~U[2026-11-21 17:45:00Z], repo_url: "not a url", demo_url: "ftp://example.com"})
      assert %{repo_url: ["must be a valid URL"], demo_url: ["must be a valid URL"]} = errors_on(changeset)
    end

    test "create_project/1 does not allow two projects for the same team" do
      project = project_fixture()
      assert {:error, changeset} = Projects.create_project(%{team_id: project.team_id, name: "other", submitted_at: ~U[2026-11-21 17:45:00Z]})
      assert %{team_id: ["has already been taken"]} = errors_on(changeset)
    end

    test "get_project_by_team/1 returns the project of the team" do
      project = project_fixture()
      assert Projects.get_project_by_team(project.team_id).id == project.id
    end

    test "get_project_by_team/1 returns nil when the team has no project" do
      assert Projects.get_project_by_team(Ecto.UUID.generate()) == nil
    end

    test "upsert_project/2 creates a project when the team has none" do
      team = Ares.TeamsFixtures.team_fixture()
      assert {:ok, %Project{} = project} =
        Projects.upsert_project(team.id, %{name: "Ares", submitted_at: ~U[2026-11-21 17:45:00Z]})
      assert project.team_id == team.id
    end

    test "upsert_project/2 updates the existing project instead of creating another" do
      project = project_fixture()
      assert {:ok, updated} =
        Projects.upsert_project(project.team_id, %{name: "new name", submitted_at: ~U[2026-11-22 17:45:00Z]})
      assert updated.id == project.id
      assert updated.name == "new name"
      assert length(Projects.list_projects()) == 1
    end

    test "upsert_project/2 with invalid data returns error changeset" do
      team = Ares.TeamsFixtures.team_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.upsert_project(team.id, @invalid_attrs)
    end
  end
end
