defmodule AresWeb.BackofficeLive.Payments do
  use AresWeb, :backoffice_view

  alias Ares.Billing

  @impl true
  def mount(_params, _session, socket) do
    payments = Billing.list_payments_with_team()
    completed = Enum.filter(payments, &(&1.status == :completed))

    {:ok,
     socket
     |> assign(:page_title, "Payments")
     |> assign(:payments, payments)
     |> assign(:completed, length(completed))
     |> assign(:pending, Enum.count(payments, &(&1.status == :pending)))
     |> assign(
       :collected,
       completed |> Enum.map(& &1.amount) |> Enum.reduce(Decimal.new(0), &Decimal.add/2)
     )}
  end

  defp format_amount(amount), do: "#{amount |> Decimal.round(2) |> Decimal.to_string()} €"
end
