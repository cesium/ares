defmodule Ares.Billing.Payment do
  @moduledoc """
  The Payment schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payments" do
    field :order_id, :string
    field :amount, :decimal
    field :status, Ecto.Enum, values: [:pending, :completed, :canceled], default: :pending

    belongs_to :team, Ares.Teams.Team, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:order_id, :amount, :status, :team_id])
    |> validate_required([:order_id, :amount, :status, :team_id])
  end
end
