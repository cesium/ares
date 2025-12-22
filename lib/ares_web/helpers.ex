defmodule AresWeb.Helpers do
  def user_first_name(full_name) do
    full_name
    |> String.split(" ")
    |> List.first()
  end
end
