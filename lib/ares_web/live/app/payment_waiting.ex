defmodule AresWeb.AppLive.PaymentWaiting do
  use AresWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-3xl mx-auto font-inter">

      </div>
    </Layouts.app>
    """
  end
end
