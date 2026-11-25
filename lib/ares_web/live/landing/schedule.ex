defmodule AresWeb.LandingLive.Schedule do
  use AresWeb, :landing_view

  import AresWeb.Components.Page

  alias Ares.Schedule
  alias Ares.Schedule.Activity

  def mount(_params, _session, socket) do
    {:ok, assign(socket, days: Schedule.list_days())}
  end

  def handle_params(params, _url, socket) do
    days = socket.assigns.days

    day =
      with d when is_binary(d) <- params["date"],
           {:ok, date} <- Date.from_iso8601(d),
           true <- date in days do
        date
      else
        _ -> List.first(days)
      end

    idx = Enum.find_index(days, &(&1 == day)) || 0

    filters = Enum.filter(Activity.types(), &(Atom.to_string(&1) in List.wrap(params["types"])))

    {:noreply,
     assign(socket,
       day: day,
       filters: filters,
       prev_day: if(idx > 0, do: Enum.at(days, idx - 1)),
       next_day: Enum.at(days, idx + 1),
       day_activities: if(day, do: Schedule.list_daily_activities(day, filters), else: [])
     )}
  end

  def types, do: Activity.types()

  def schedule_path(day, filters),
    do: ~p"/schedule?#{%{date: Date.to_iso8601(day), types: filters}}"

  def toggle(filters, type) do
    if type in filters, do: List.delete(filters, type), else: filters ++ [type]
  end
end
