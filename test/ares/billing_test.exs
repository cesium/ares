defmodule Ares.BillingTest do
  use Ares.DataCase

  alias Ares.Billing

  describe "payments" do
    alias Ares.Billing.Payment

    import Ares.BillingFixtures

    @invalid_attrs %{status: nil, order_id: nil, amount: nil}

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Billing.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Billing.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      payment = payment_fixture()

      valid_attrs = %{
        status: :completed,
        order_id: "some order_id",
        amount: "120.5",
        team_id: payment.team_id
      }

      assert {:ok, %Payment{} = payment} = Billing.create_payment(valid_attrs)
      assert payment.status == :completed
      assert payment.order_id == "some order_id"
      assert payment.amount == Decimal.new("120.5")
      assert payment.team_id == payment.team_id
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()

      update_attrs = %{
        status: :completed,
        order_id: "some updated order_id",
        amount: "456.7"
      }

      assert {:ok, %Payment{} = payment} = Billing.update_payment(payment, update_attrs)
      assert payment.status == :completed
      assert payment.order_id == "some updated order_id"
      assert payment.amount == Decimal.new("456.7")
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_payment(payment, @invalid_attrs)
      assert payment == Billing.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Billing.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Billing.change_payment(payment)
    end
  end
end
