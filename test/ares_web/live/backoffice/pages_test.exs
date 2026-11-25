defmodule AresWeb.BackofficeLive.PagesTest do
  use AresWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ares.AccountsFixtures
  import Ares.TeamsFixtures
  import Ares.BillingFixtures

  setup %{conn: conn} do
    admin = user_fixture() |> Ecto.Changeset.change(type: :admin) |> Ares.Repo.update!()
    %{conn: log_in_user(conn, admin)}
  end

  defp info(view, name), do: view |> element("dl > div", name) |> render()

  test "attendees page lists attendees with counts", %{conn: conn} do
    user_fixture(%{name: "Ada Lovelace"})
    {:ok, view, html} = live(conn, ~p"/backoffice/attendees")
    assert html =~ "Ada Lovelace"
    assert info(view, "Without team") =~ ~r/>\s*1\s*</
    assert has_element?(view, "#page-sidebar-desktop a[aria-current=page]", "Attendees")
  end

  test "teams page lists teams with payment status", %{conn: conn} do
    team_fixture(%{name: "Byte Me"})
    {:ok, view, html} = live(conn, ~p"/backoffice/teams")
    assert html =~ "Byte Me"
    assert has_element?(view, "#teams-table", "None")
    assert info(view, "Pending") =~ ~r/>\s*1\s*</
  end

  test "payments page lists payments and sums completed ones", %{conn: conn} do
    payment_fixture(%{order_id: "ORD-1", amount: "20", status: "completed"})
    payment_fixture(%{order_id: "ORD-2", amount: "15.5", status: "pending"})
    {:ok, view, html} = live(conn, ~p"/backoffice/payments")
    assert html =~ "ORD-1"
    assert html =~ "ORD-2"
    assert info(view, "Collected") =~ "20.00 €"
    assert has_element?(view, "#page-sidebar-desktop a[aria-current=page]", "Payments")
  end

  test "empty tables show a placeholder", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/backoffice/payments")
    assert html =~ "Nothing here yet."
  end
end
