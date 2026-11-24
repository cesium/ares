defmodule AresWeb.BackofficeLive.ScheduleTest do
  use AresWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ares.AccountsFixtures
  import Ares.ScheduleFixtures

  defp log_in_admin(%{conn: conn}) do
    user = user_fixture() |> Ecto.Changeset.change(type: :admin) |> Ares.Repo.update!()
    %{conn: log_in_user(conn, user)}
  end

  test "non-admins are redirected", %{conn: conn} do
    conn = log_in_user(conn, user_fixture())
    assert {:error, {:redirect, %{to: "/app/profile"}}} = live(conn, ~p"/backoffice/schedule")
  end

  describe "as admin" do
    setup :log_in_admin

    test "creates, edits and deletes an activity", %{conn: conn} do
      {:ok, view, _} = live(conn, ~p"/backoffice/schedule/new")

      assert view
             |> form("#activity-form", activity: %{title: ""})
             |> render_change() =~ "can&#39;t be blank"

      view
      |> form("#activity-form",
        activity: %{title: "Hacking Starts", type: "activity", date: "2026-11-19", time: "11:00"}
      )
      |> render_submit()

      assert_patch(view, ~p"/backoffice/schedule")
      assert render(view) =~ "Hacking Starts"

      [activity] = Ares.Schedule.list_activities()
      {:ok, view, _} = live(conn, ~p"/backoffice/schedule/#{activity.id}/edit")
      view |> form("#activity-form", activity: %{title: "Hacking Begins"}) |> render_submit()
      assert render(view) =~ "Hacking Begins"

      view |> element("#activities-table a[data-confirm]") |> render_click()
      assert Ares.Schedule.list_activities() == []
    end

    test "sidebar highlights the current page", %{conn: conn} do
      {:ok, view, _} = live(conn, ~p"/backoffice/schedule/new")
      assert has_element?(view, "#page-sidebar-desktop a[aria-current=page]", "Schedule")
      refute has_element?(view, "#page-sidebar-desktop a[aria-current=page]", "Companies")

      {:ok, view, _} = live(conn, ~p"/backoffice/teams")
      assert has_element?(view, "#page-sidebar-desktop a[aria-current=page]", "Teams")
      assert has_element?(view, "a[href='/users/log-out']")
    end

    test "lists existing activities", %{conn: conn} do
      activity_fixture(%{title: "Pitches"})
      {:ok, _view, html} = live(conn, ~p"/backoffice/schedule")
      assert html =~ "Pitches"
    end
  end
end
