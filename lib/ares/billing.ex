defmodule Ares.Billing do
  @moduledoc """
  The Billing context.
  """

  import Ecto.Query, warn: false
  alias Ares.Repo

  alias Ares.Accounts
  alias Ares.Teams

  def start_payment(:mbway, team_id, order_data) do
    team = Teams.get_team!(team_id)
    leader = Accounts.get_user!(team.leader_id)
    checkout_info = get_checkout_infomation(team_id)

    midas_api_url = midas_api_url()
    ticket_product_id = ticket_product_id()
    midas_api_key = midas_api_key()

    IO.inspect(order_data)

    cond do
      not is_binary(midas_api_url) ->
        {:error, :missing_midas_api_url}

      is_nil(ticket_product_id) ->
        {:error, :missing_ticket_product_id}

      not is_binary(midas_api_key) or midas_api_key == "" ->
        {:error, :missing_midas_api_key}

      true ->
        case Req.post(midas_api_url <> "/orders",
               headers: [{"authorization", "Bearer " <> midas_api_key}],
               json: %{
                 order: %{
                   lines: [
                     %{
                       product_id: ticket_product_id,
                       quantity: checkout_info.quantity,
                       discount: 0
                     }
                   ]
                 },
                 customer_email: leader.email,
                 customer_name: leader.name,
                 customer_tax_id:
                   if order_data["tax_id"] == "" do
                     nil
                   else
                     order_data["tax_id"]
                   end,
                 payment: %{
                   method: "mbway",
                   phone_number: order_data["phone_number"]
                 },
                 message: "CeSIUM - BugsByte 2026 Tickets",
                 extra_fields: %{team_id: team_id}
               }
             ) do
          {:ok, %Req.Response{status: 201, body: body}} ->
            IO.inspect(body, label: "Midas order created")
            {:ok, body}

          {:ok, %Req.Response{status: status, body: body}} ->
            {:error, %{status: status, body: body}}

          {:error, reason} ->
            {:error, reason}
        end
    end
  end

  def get_checkout_infomation(team_id) do
    team = Teams.get_team!(team_id)

    %{
      quantity: length(team.members),
      per_unit: get_ticket_price(),
      total: length(team.members) * get_ticket_price()
    }
  end

  defp get_ticket_price do
    Application.fetch_env!(:ares, Ares.Billing)[:ticket_price]
  end

  defp midas_api_url do
    Application.fetch_env!(:ares, Ares.Billing)[:midas_api_url]
  end

  defp midas_api_key do
    Application.fetch_env!(:ares, Ares.Billing)[:midas_api_key]
  end

  defp ticket_product_id do
    Application.fetch_env!(:ares, Ares.Billing)[:ticket_product_id]
  end
end
