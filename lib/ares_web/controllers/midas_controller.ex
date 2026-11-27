defmodule AresWeb.MidasController do
  use AresWeb, :controller
  alias Ares.Billing

  @doc """
  Handle Midas payment webhook.
  """
  def handle_webhook(conn, %{"ares_api_key" => ares_api_key, "order_id" => order_id} = _params) do
    if ares_api_key == Application.fetch_env!(:ares, Ares.Billing)[:ares_api_key] do
      payment = Billing.get_payment_by_order_id(order_id)

      if payment && payment.status != :completed do
        case Billing.mark_payment_completed(order_id) do
          {:error, reason} ->
            send_resp(conn, 400, "error: #{inspect(reason)}")

          _ ->
            send_resp(conn, 200, "success")
        end
      else
        send_resp(conn, 404, "payment not found")
      end
    else
      send_resp(conn, 403, "invalid api key")
    end
  end
end
