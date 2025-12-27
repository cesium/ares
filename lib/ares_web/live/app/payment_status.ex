defmodule AresWeb.AppLive.PaymentStatus do
  use AresWeb, :live_view

  alias Ares.Billing

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-3xl mx-auto font-inter my-16">
        <.icon :if={@payment.status == :pending} name="hero-clock" class="text-gray-400 mb-4 size-20" />
        <.icon
          :if={@payment.status == :completed}
          name="hero-check"
          class="text-gray-400 mb-4 size-20"
        />
        <h3 class="mb-3 text-lg">Order #{@payment.order_id}</h3>
        <%= if @payment.status == :pending do %>
          <h2 class="text-2xl font-resegrg mb-2">Waiting for payment</h2>
          <p class="text-lg text-gray-300">
            We are waiting for your MB Way payment confirmation. This page will update once the payment is completed.
          </p>
        <% end %>
        <%= if @payment.status == :completed do %>
          <h2 class="text-2xl font-resegrg mb-2">Payment completed</h2>
          <p class="text-lg text-gray-300">
            Thank you for your payment. Your transaction has been successfully processed.
          </p>
          <p class="text-lg text-gray-300">We look forward to seeing you at the event!</p>
          <.button patch={~p"/app/profile"} class="mt-6 btn btn-primary">
            <.icon name="hero-arrow-left" class="size-4 mr-2" /> Return to Profile
          </.button>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => order_id}, _session, socket) do
    if connected?(socket) do
      Billing.subscribe_to_payment_order_updates(order_id)
    end

    payment = Billing.get_payment_by_order_id!(order_id)
    {:ok, assign(socket, payment: payment)}
  end

  @impl true
  def handle_info({:payment_order_updated, payment}, socket) do
    {:noreply,
     socket
     |> assign(payment: payment)
     |> put_flash(:info, "Payment confirmed successfully.")}
  end
end
