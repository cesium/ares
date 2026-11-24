defmodule AresWeb.BackofficeLive.EventSettingsTest do
  use AresWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ares.AccountsFixtures

  alias Ares.Event

  setup %{conn: conn} do
    admin = user_fixture() |> Ecto.Changeset.change(type: :admin) |> Ares.Repo.update!()
    %{conn: log_in_user(conn, admin)}
  end

  test "toggles registrations", %{conn: conn} do
    {:ok, view, _} = live(conn, ~p"/backoffice/event_settings")
    refute Event.registrations_enabled?()

    view |> element("#registrations-toggle") |> render_click()
    assert Event.registrations_enabled?()
    assert view |> element("dl > div", "Registrations") |> render() =~ "Open"

    view |> element("#registrations-toggle") |> render_click()
    refute Event.registrations_enabled?()
  end

  test "validates and saves the attendees limit", %{conn: conn} do
    {:ok, view, _} = live(conn, ~p"/backoffice/event_settings")

    assert view |> form("#limit-form", %{limit: "0"}) |> render_change() =~
             "must be a positive whole number"

    assert view |> form("#limit-form", %{limit: "abc"}) |> render_submit() =~
             "must be a positive whole number"

    assert Event.get_attendees_limit() == nil

    view |> form("#limit-form", %{limit: "120"}) |> render_submit()
    assert Event.get_attendees_limit() == 120
    assert render(view) =~ "Attendees limit updated."
  end

  test "warns when enabled but closed by the limit", %{conn: conn} do
    Event.change_registrations_open("true")
    Event.change_attendees_limit(1)
    Ares.TeamsFixtures.team_fixture()
    team = Ares.Teams.list_teams() |> hd()

    for _ <- 1..2,
        do: user_fixture() |> Ecto.Changeset.change(team_id: team.id) |> Ares.Repo.update!()

    {:ok, _view, html} = live(conn, ~p"/backoffice/event_settings")
    assert html =~ "Enabled, but closed"
  end
end
