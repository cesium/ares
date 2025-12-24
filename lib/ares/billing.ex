defmodule Ares.Billing do
  @moduledoc """
  The Billing context.
  """

  import Ecto.Query, warn: false

  alias Ares.Repo

  alias Ares.{Accounts, Teams}
  alias Ares.Billing.Payment

  @pubsub Ares.PubSub

  def start_payment(:mbway, team_id, order_data) do
    team = Teams.get_team!(team_id)
    leader = Accounts.get_user!(team.leader_id)
    checkout_info = get_checkout_infomation(team_id)

    midas_api_url = midas_api_url()
    ticket_product_id = ticket_product_id()
    midas_api_key = midas_api_key()

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
                   ],
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
               }
             ) do
          {:ok, %Req.Response{status: 201, body: body}} ->
            {:ok,
             create_payment(%{
               amount: checkout_info.total,
               order_id: body["id"],
               status: :pending,
               team_id: team_id
             })}

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

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments do
    Repo.all(Payment)
  end

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!(123)
      %Payment{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id), do: Repo.get!(Payment, id)

  @doc """
  Gets a single payment by order_id.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment_by_order_id!("some order_id")
      %Payment{}

      iex> get_payment_by_order_id!("nonexistent order_id")
      ** (Ecto.NoResultsError)

  """
  def get_payment_by_order_id!(order_id) do
    Repo.get_by!(Payment, order_id: order_id)
  end

  @doc """
  Gets a single payment by order_id.

  ## Examples

      iex> get_payment_by_order_id("some order_id")
      %Payment{}

      iex> get_payment_by_order_id("nonexistent order_id")
      nil

  """
  def get_payment_by_order_id(order_id) do
    Repo.get_by(Payment, order_id: order_id)
  end

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %Payment{}}

      iex> create_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment(attrs) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment.

  ## Examples

      iex> update_payment(payment, %{field: new_value})
      {:ok, %Payment{}}

      iex> update_payment(payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a payment.

  ## Examples

      iex> delete_payment(payment)
      {:ok, %Payment{}}

      iex> delete_payment(payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment(%Payment{} = payment) do
    Repo.delete(payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment changes.

  ## Examples

      iex> change_payment(payment)
      %Ecto.Changeset{data: %Payment{}}

  """
  def change_payment(%Payment{} = payment, attrs \\ %{}) do
    Payment.changeset(payment, attrs)
  end

  @doc """
  Marks a payment as completed.

  ## Examples

      iex> mark_payment_completed(order_id)
      {:ok, %Payment{}}

      iex> mark_payment_completed(invalid_order_id)
      {:error, %Ecto.Changeset{}}

  """
  def mark_payment_completed(order_id) do
    payment = get_payment_by_order_id!(order_id)

    Teams.mark_team_as_paid(payment.team_id)

    update_payment(payment, %{status: :completed})
    |> broadcast_payment_order_update()
  end

  def subscribe_to_payment_order_updates(order_id) do
    Phoenix.PubSub.subscribe(@pubsub, "payment_order:#{order_id}")
  end

  defp broadcast_payment_order_update({:ok, %Payment{} = payment} = result) do
    Phoenix.PubSub.broadcast(
      @pubsub,
      "payment_order:#{payment.order_id}",
      {:payment_order_updated, payment}
    )

    result
  end
end
