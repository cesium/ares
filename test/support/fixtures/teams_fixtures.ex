defmodule Ares.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ares.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        code: "some code",
        description: "some description",
        experience_level: "some experience_level",
        name: "some name",
        paid: true,
        public: true,
        skills_needed: "some skills_needed"
      })
      |> Ares.Teams.create_team()

    team
  end
end
