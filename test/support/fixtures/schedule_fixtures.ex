defmodule Ares.ScheduleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ares.Schedule` context.
  """

  @doc """
  Generate an activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        date: ~D[2026-11-23],
        description: "some description",
        time: ~T[14:00:00],
        title: "some title",
        type: :activity
      })
      |> Ares.Schedule.create_activity()

    activity
  end
end
