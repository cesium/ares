defmodule AresWeb.Components.PaymentBadge do
  @moduledoc """
  Badge for payment statuses, both a team's (`:none | :started | :paid`)
  and a payment's (`:pending | :completed | :canceled`).
  """
  use Phoenix.Component

  attr :status, :atom,
    required: true,
    values: [:none, :started, :paid, :pending, :completed, :canceled]

  def payment_badge(assigns) do
    ~H"""
    <span class={[
      "inline-flex items-center rounded-full px-3 py-1 text-xs uppercase tracking-widest",
      color(@status)
    ]}>
      {@status |> to_string() |> String.capitalize()}
    </span>
    """
  end

  defp color(status) when status in [:paid, :completed], do: "bg-emerald-500/15 text-emerald-300"
  defp color(status) when status in [:started, :pending], do: "bg-amber-500/15 text-amber-300"
  defp color(status) when status in [:none, :canceled], do: "bg-red-500/15 text-red-300"
end
