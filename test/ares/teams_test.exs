defmodule Ares.TeamsTest do
  use Ares.DataCase

  alias Ares.Teams

  describe "teams" do
    alias Ares.Teams.Team

    import Ares.TeamsFixtures

    @invalid_attrs %{
      code: nil,
      name: nil,
      public: nil,
      description: nil,
      skills_needed: nil,
      experience_level: nil,
      paid: nil
    }

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{
        code: "some code",
        name: "some name",
        public: true,
        description: "some description",
        skills_needed: "some skills_needed",
        experience_level: "some experience_level",
        paid: true
      }

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.code == "some code"
      assert team.name == "some name"
      assert team.public == true
      assert team.description == "some description"
      assert team.skills_needed == "some skills_needed"
      assert team.experience_level == "some experience_level"
      assert team.paid == true
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()

      update_attrs = %{
        code: "some updated code",
        name: "some updated name",
        public: false,
        description: "some updated description",
        skills_needed: "some updated skills_needed",
        experience_level: "some updated experience_level",
        paid: false
      }

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.code == "some updated code"
      assert team.name == "some updated name"
      assert team.public == false
      assert team.description == "some updated description"
      assert team.skills_needed == "some updated skills_needed"
      assert team.experience_level == "some updated experience_level"
      assert team.paid == false
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end
end
