defmodule Ares.Companies.Company do
  @moduledoc """
  Represents companies sponsoring the event.
  """
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(name)a
  @optional_fields ~w(url)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :url, :string
    field :logo, Ares.Uploaders.Company.Type

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  @doc false
  def image_changeset(company, attrs) do
    company
    |> cast_attachments(attrs, [:logo])
  end
end
