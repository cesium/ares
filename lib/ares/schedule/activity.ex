defmodule Ares.Schedule.Activity do
  @moduledoc """
  An activity in the event schedule.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @types [:activity, :food, :submission]

  @required_fields ~w(title type date time)a
  @optional_fields ~w(description)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    field :title, :string
    field :description, :string
    field :type, Ecto.Enum, values: @types, default: :activity
    field :date, :date
    field :time, :time

    timestamps(type: :utc_datetime)
  end

  def types, do: @types

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
