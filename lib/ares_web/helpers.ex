defmodule AresWeb.Helpers do
  @moduledoc """
  Helper functions for the web layer.
  """
  def user_first_name(full_name) do
    full_name
    |> String.split(" ")
    |> List.first()
  end

  def first_last_name(full_name) do
    names = String.split(full_name, " ")
    first = List.first(names)
    last = List.last(names)

    if first == last do
      first
    else
      "#{first} #{last}"
    end
  end
end
