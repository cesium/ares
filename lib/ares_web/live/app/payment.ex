defmodule AresWeb.AppLive.Payment do
  use AresWeb, :live_view

  alias Ares.{Accounts, Billing, Event, Teams}
  alias Ecto.Changeset

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-7xl mx-auto font-inter">
        <%= if @step == :none do %>
          <h3 class="text-3xl font-resegrg mb-2">{@team.name}</h3>
          <p class="text-lg">To proceed with payment, please confirm your team members:</p>
          <div class="mb-6 pb-6">
            <div>
              <div class="space-y-2 my-2">
                <%= for member <- @team.members do %>
                  <div class="py-4">
                    <div class="flex flex-row justify-between items-center">
                      <div>
                        <p class="font-semibold text-white text-lg flex flex-row items-center gap-2">
                          {first_last_name(member.name)}
                          <.icon :if={@team.leader_id == member.id} name="hero-star" />
                        </p>
                        <p class="text-gray-400">{member.email}</p>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
            <%= if reaches_limit_with_current_team?(@team.members) do %>
              <div class="alert alert-error mb-8">
                <.icon name="hero-exclamation-triangle" class="size-6 shrink-0" />
                <div>
                  <p>
                    Your team exceeds the total capacity for the event. You cannot proceed to payment.
                  </p>
                </div>
              </div>
            <% else %>
              <div class="alert alert-error">
                <.icon name="hero-exclamation-triangle" class="size-6 shrink-0" />
                <div>
                  <p>After confirmation, this list <b>cannot be changed</b>.</p>
                </div>
              </div>
            <% end %>
            <div class="flex flex-row justify-between mt-8 gap-4">
              <.button
                patch={~p"/app/profile"}
                class="btn btn-primary btn-soft w-2/5"
              >
                <.icon name="hero-arrow-left" class="mr-2" /> Cancel
              </.button>
              <.button
                class="btn btn-primary w-2/5"
                phx-click="start-payment"
                disabled={reaches_limit_with_current_team?(@team.members)}
              >
                Confirm <.icon name="hero-arrow-right" class="ml-2" />
              </.button>
            </div>
          </div>
        <% end %>
        <%= if @step == :started do %>
          <%= if reaches_limit_with_current_team?(@team.members) do %>
            <div class="alert alert-error mb-8">
              <.icon name="hero-exclamation-triangle" class="size-6 shrink-0" />
              <div>
                <p>
                  Your team exceeds the total capacity for the event. You cannot complete the payment.
                </p>
              </div>
            </div>
          <% end %>
          <.form for={@payment_form} phx-change="validate-payment" phx-submit="submit-payment">
            <div class="flex flex-col sm:flex-row gap-8 min-h-[650px]">
              <div class="w-full">
                <h2 class="text-xl pb-2">Contact information</h2>
                <div class="w-full pb-6">
                  <.input name="name" label="Name" value={@user.name} type="text" readonly />
                  <.input
                    name="email"
                    label="Email address"
                    value={@user.email}
                    type="email"
                    readonly
                  />
                </div>
                <h2 class="text-xl pb-2">Billing information</h2>
                <div class="flex items-center gap-2">
                  <input
                    id="include-invoice-info"
                    type="checkbox"
                    class="checkbox checkbox-primary"
                    phx-click="toggle-invoice-info"
                    checked={@include_invoice_info}
                  />
                  <label for="include-invoice-info" class="text-sm">
                    Include invoice info
                  </label>
                </div>
                <div :if={@include_invoice_info} class="mt-4">
                  <.input
                    field={@payment_form[:iva_number]}
                    label="NIF"
                    placeholder="212345678"
                    type="text"
                  />
                </div>
                <h2 class="text-xl pb-2 mt-6">Payment method</h2>
                <div class="flex items-start gap-2">
                  <input
                    id="payment-method-mb-way"
                    type="radio"
                    name="payment_method"
                    class="radio radio-primary mt-1"
                    value="mb_way"
                    checked={@payment_method == "mb_way"}
                  />
                  <label for="payment-method-mb-way" class="text-sm">
                    <img src="/images/mbway.svg" alt="Mb Way" class="inline h-8 ml-1 mr-2 mb-1" />
                  </label>
                </div>
                <div class="mt-4">
                  <.input
                    field={@payment_form[:mb_way_phone]}
                    label="Phone number"
                    type="tel"
                    placeholder="912345678"
                    phx-debounce="300"
                  />
                </div>
              </div>
              <div class="w-full">
                <h2 class="text-xl pb-2">Order summary</h2>
                <div class="mt-4 p-4 border border-gray-800 rounded-lg">
                  <div class="flex flex-row justify-between mb-2">
                    <div>
                      <p>{@checkout_information.quantity}× BugsByte Hackathon 2026 Ticket</p>
                    </div>
                    <p>€{@checkout_information.per_unit}</p>
                  </div>
                  <div class="flex flex-row justify-between font-bold border-t border-gray-700 pt-2">
                    <p>Total</p>
                    <p>€{@checkout_information.total}</p>
                  </div>
                </div>
                <.button
                  class="btn btn-primary w-full mt-6"
                  disabled={
                    !@payment_changeset.valid? || reaches_limit_with_current_team?(@team.members)
                  }
                >
                  Complete payment
                </.button>
              </div>
            </div>
          </.form>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

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
