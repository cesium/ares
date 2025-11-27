defmodule AresWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use AresWeb, :html

  embed_templates "page_html/*"

  def count_team_members(team) do
    members = [
      team.captain_name,
      team.member1_name,
      team.member2_name,
      team.member3_name,
      team.member4_name
    ]

    Enum.count(members, fn member -> member && String.trim(member) != "" end)
  end

  def count_teams_looking_for_members(teams) do
    Enum.count(teams, & &1.looking_for_members)
  end

  def total_members(teams) do
    Enum.reduce(teams, 0, fn team, acc ->
      acc + count_team_members(team)
    end)
  end

  def average_team_size([]), do: 0

  def average_team_size(teams) do
    total = total_members(teams)
    (total / Enum.count(teams)) |> Float.round(1)
  end
end
