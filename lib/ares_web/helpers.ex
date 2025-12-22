defmodule AresWeb.Helpers do
  def user_first_name(full_name) do
    full_name
    |> String.split(" ")
    |> List.first()
  end

  def first_last_name(full_name) do
    names = String.split(full_name, " ")
    first = List.first(names)
    last = List.last(names)
    "#{first} #{last}"
  end
end
