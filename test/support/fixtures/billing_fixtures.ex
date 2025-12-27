defmodule Ares.BillingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ares.Billing` context.
  """
  alias Ares.TeamsFixtures

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    {:ok, payment} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        order_id: "order_id",
        status: "pending",
        team_id: TeamsFixtures.team_fixture().id
      })
      |> Ares.Billing.create_payment()

    payment
  end
end
