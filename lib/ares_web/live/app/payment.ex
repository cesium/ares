defmodule AresWeb.AppLive.Payment do
  use AresWeb, :app_view

  on_mount {AresWeb.UserAuth, :require_authenticated}

  alias Ares.{Accounts, Billing, Event, Teams}
  alias Ecto.Changeset

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket) do
    team = Teams.get_team!(user.team_id)

    cond do
      is_nil(team) ->
        deny(socket, "Please join a team first.")

      length(team.members) < 2 ->
        deny(socket, "At least 2 team members are required to proceed with payment.")

      team.leader_id != user.id ->
        deny(socket, "Only the team leader can access the payment page.")

      team.payment_status == :paid ->
        info(socket, "Your team has already completed the payment.")

      payment_in_progress?(team) ->
        info(
          socket,
          "A payment is already in progress for your team. Please complete it or contact support."
        )

      true ->
        {:ok,
         socket
         |> assign(:user, user)
         |> assign(:team, team)
         |> assign(:checkout_information, Billing.get_checkout_infomation(team.id))
         |> assign(:step, team.payment_status)
         |> assign(:include_invoice_info, false)
         |> assign(:iva_number, "")
         |> assign(:payment_method, "mb_way")
         |> assign(:mb_way_phone, "")
         |> assign_payment_form(payment_changeset(%{mb_way_phone: "", iva_number: ""}, false))}
    end
  end

  @impl true
  def handle_event("toggle-invoice-info", _params, socket) do
    include_invoice_info = !socket.assigns.include_invoice_info

    changeset =
      payment_changeset(
        %{mb_way_phone: socket.assigns.mb_way_phone, iva_number: socket.assigns.iva_number},
        include_invoice_info
      )

    {:noreply,
     socket
     |> assign(:include_invoice_info, include_invoice_info)
     |> assign_payment_form(Map.put(changeset, :action, :validate))}
  end

  @impl true
  def handle_event("validate-payment", %{"payment" => payment_params}, socket) do
    phone = Map.get(payment_params, "mb_way_phone", "")
    iva_number = Map.get(payment_params, "iva_number", "")

    changeset =
      payment_changeset(
        %{mb_way_phone: phone, iva_number: iva_number},
        socket.assigns.include_invoice_info
      )
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:mb_way_phone, phone)
     |> assign(:iva_number, iva_number)
     |> assign_payment_form(changeset)}
  end

  @impl true
  def handle_event("submit-payment", %{"payment" => payment_params}, socket) do
    if reaches_limit_with_current_team?(socket.assigns.team.members) do
      {:noreply,
       socket
       |> put_flash(
         :error,
         "Your team exceeds the total capacity for the event. You cannot complete the payment."
       )}
    else
      phone = Map.get(payment_params, "mb_way_phone", "")
      iva_number = Map.get(payment_params, "iva_number", "")

      changeset =
        payment_changeset(
          %{mb_way_phone: phone, iva_number: iva_number},
          socket.assigns.include_invoice_info
        )
        |> Map.put(:action, :validate)

      if changeset.valid? do
        order_data = %{
          "phone_number" => phone,
          "tax_id" => if(socket.assigns.include_invoice_info, do: iva_number, else: "")
        }

        case Billing.start_payment(:mbway, socket.assigns.team.id, order_data) do
          {:ok, {:ok, payment}} ->
            {:noreply, push_navigate(socket, to: ~p"/app/payment/#{payment.order_id}")}

          {:error, _reason} ->
            {:noreply,
             socket
             |> put_flash(:error, "Failed to start payment. Please try again later.")
             |> assign_payment_form(changeset)}
        end
      else
        {:noreply, assign_payment_form(socket, changeset)}
      end
    end
  end

  @impl true
  def handle_event("start-payment", _params, %{assigns: %{step: :none, team: team}} = socket) do
    if reaches_limit_with_current_team?(socket.assigns.team.members) do
      {:noreply,
       socket
       |> put_flash(
         :error,
         "Your team exceeds the total capacity for the event. You cannot proceed to payment."
       )}
    else
      case Teams.update_team(team, %{payment_status: :started}) do
        {:ok, _team} ->
          {:noreply, assign(socket, :step, :started)}

        {:error, _changeset} ->
          {:noreply,
           socket
           |> put_flash(:error, "Failed to start confirm team data. Please try again later.")
           |> redirect(to: ~p"/app/profile")}
      end
    end
  end

  defp valid_pt_phone?(phone) do
    normalized = phone |> String.trim() |> String.replace(~r/\s+/, "")
    Regex.match?(~r/^(?:\+351|351)?9\d{8}$/, normalized)
  end

  defp validate_pt_phone(changeset, field) do
    Changeset.validate_change(changeset, field, fn _, value ->
      if value in [nil, ""] or valid_pt_phone?(value) do
        []
      else
        [{field, "invalid phone number"}]
      end
    end)
  end

  defp validate_pt_nif(changeset, field) do
    Changeset.validate_change(changeset, field, fn _, value ->
      if value in [nil, ""] or valid_pt_nif?(value) do
        []
      else
        [{field, "invalid NIF"}]
      end
    end)
  end

  defp valid_pt_nif?(nif) do
    normalized = nif |> String.trim() |> String.replace(~r/\s+/, "")

    with true <- Regex.match?(~r/^\d{9}$/, normalized),
         digits <- normalized |> String.graphemes() |> Enum.map(&String.to_integer/1),
         [check | rest] <- Enum.reverse(digits) do
      sum =
        rest
        |> Enum.reverse()
        |> Enum.with_index()
        |> Enum.reduce(0, fn {digit, index}, acc -> acc + digit * (9 - index) end)

      expected = rem(11 - rem(sum, 11), 11)
      (expected == 10 && check == 0) || check == expected
    else
      _ -> false
    end
  end

  defp payment_changeset(attrs, include_invoice_info) do
    types = %{mb_way_phone: :string, iva_number: :string}

    {%{}, types}
    |> Changeset.cast(attrs, Map.keys(types))
    |> Changeset.validate_required([:mb_way_phone])
    |> validate_pt_phone(:mb_way_phone)
    |> maybe_validate_nif(include_invoice_info)
  end

  defp maybe_validate_nif(changeset, true) do
    changeset
    |> Changeset.validate_required([:iva_number])
    |> validate_pt_nif(:iva_number)
  end

  defp maybe_validate_nif(changeset, false), do: changeset

  defp assign_payment_form(socket, %Changeset{} = changeset) do
    form = to_form(changeset, as: :payment)

    socket
    |> assign(:payment_form, form)
    |> assign(:payment_changeset, changeset)
  end

  defp deny(socket, message) do
    {:ok,
     socket
     |> put_flash(:error, message)
     |> redirect(to: ~p"/app/profile")}
  end

  defp info(socket, message) do
    {:ok,
     socket
     |> put_flash(:info, message)
     |> redirect(to: ~p"/app/profile")}
  end

  defp payment_in_progress?(team) do
    Billing.list_payments_by_team(team.id)
    |> Enum.any?(fn payment -> payment.status == :pending end)
  end

  defp reaches_limit_with_current_team?(team_members) do
    attendees_with_paid_team = Accounts.count_attendees_with_paid_team()
    Event.attendees_limit_reached?(attendees_with_paid_team + Enum.count(team_members))
  end
end
