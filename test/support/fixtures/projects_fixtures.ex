defmodule Ares.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ares.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        demo_url: "https://example.com",
        description: "some description",
        name: "some name",
        repo_url: "https://github.com",
        submitted_at: ~U[2026-11-21 17:45:00Z]
      })
      |> Map.put_new_lazy(:team_id, fn -> Ares.TeamsFixtures.team_fixture().id end)
      |> Ares.Projects.create_project()

    project
  end
end
