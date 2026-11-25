defmodule Ares.ScheduleTest do
  use Ares.DataCase

  alias Ares.Schedule
  alias Ares.Schedule.Activity

  import Ares.ScheduleFixtures

  @invalid_attrs %{type: nil, date: nil, time: nil, title: nil}

  test "list_daily_activities/2 filters by day and type, ordered by time" do
    lunch = activity_fixture(%{type: :food, time: ~T[13:00:00]})
    talk = activity_fixture(%{type: :activity, time: ~T[10:00:00]})
    _other_day = activity_fixture(%{date: ~D[2026-11-24]})

    assert Schedule.list_daily_activities(~D[2026-11-23]) == [talk, lunch]
    assert Schedule.list_daily_activities(~D[2026-11-23], [:food]) == [lunch]
  end

  test "list_days/0 returns distinct sorted days" do
    activity_fixture(%{date: ~D[2026-11-24]})
    activity_fixture(%{date: ~D[2026-11-23]})
    activity_fixture(%{date: ~D[2026-11-23]})

    assert Schedule.list_days() == [~D[2026-11-23], ~D[2026-11-24]]
  end

  test "create_activity/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Schedule.create_activity(@invalid_attrs)
  end

  test "update_activity/2 and delete_activity/1" do
    activity = activity_fixture()
    assert {:ok, %Activity{title: "new"}} = Schedule.update_activity(activity, %{title: "new"})
    assert {:ok, %Activity{}} = Schedule.delete_activity(activity)
    assert_raise Ecto.NoResultsError, fn -> Schedule.get_activity!(activity.id) end
  end
end
