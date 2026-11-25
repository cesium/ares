defmodule AresWeb.LandingLive.ScheduleTest do
  use AresWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ares.ScheduleFixtures

  defp seed(_) do
    activity_fixture(%{title: "Check-in", date: ~D[2026-11-19], time: ~T[09:00:00]})
    activity_fixture(%{title: "Lunch", type: :food, date: ~D[2026-11-19], time: ~T[13:00:00]})
    activity_fixture(%{title: "Mentoring Round", date: ~D[2026-11-20]})
    activity_fixture(%{title: "Breakfast", type: :food, date: ~D[2026-11-20]})
    activity_fixture(%{title: "Pitches", date: ~D[2026-11-21]})
    :ok
  end

  test "shows a placeholder when there are no activities", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/schedule")
    assert html =~ "announced soon"
  end

  describe "with activities" do
    setup :seed

    test "shows one day at a time and navigates with arrows", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/schedule")
      assert html =~ "Check-in"
      refute html =~ "Pitches"
      refute has_element?(view, "a[aria-label='Previous day']")

      view |> element("a[aria-label='Next day']") |> render_click()
      assert_patch(view, ~p"/schedule?date=2026-11-20")
      assert render(view) =~ "Mentoring Round"
      refute render(view) =~ "Check-in"

      {:ok, view, html} = live(conn, ~p"/schedule?date=2026-11-21")
      assert html =~ "Pitches"
      refute has_element?(view, "a[aria-label='Next day']")

      {:ok, _view, html} = live(conn, ~p"/schedule?date=garbage")
      assert html =~ "Check-in"
    end

    test "filters by type and keeps filter across days", %{conn: conn} do
      {:ok, view, _} = live(conn, ~p"/schedule")

      view |> element("a", "food") |> render_click()
      html = render(view)
      assert html =~ "Lunch"
      refute html =~ "Check-in"

      view |> element("a[aria-label='Next day']") |> render_click()
      html = render(view)
      assert html =~ "Breakfast"
      refute html =~ "Mentoring Round"

      {:ok, _view, html} = live(conn, "/schedule?types[]=bogus")
      assert html =~ "Check-in"
    end
  end
end
