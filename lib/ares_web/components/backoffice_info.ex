defmodule AresWeb.Components.BackofficeInfo do
  @moduledoc """
  A row of labelled numbers shown at the top of backoffice pages.
  """
  use Phoenix.Component

  @doc """
  Renders one card per `:info` slot.

  ## Examples

      <.backoffice_info>
        <:info name="Teams">{@team_count}</:info>
        <:info name="Paid" class="text-emerald-300">{@paid_count}</:info>
      </.backoffice_info>
  """
  slot :info, required: true do
    attr :name, :string, required: true
    attr :class, :string, doc: "extra classes for the number, e.g. a colour"
  end

  def backoffice_info(assigns) do
    ~H"""
    <dl class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6 font-inter">
      <div :for={info <- @info} class="rounded-lg border border-line bg-background px-5 py-4">
        <dt class="text-xs uppercase tracking-widest text-subtle">{info.name}</dt>
        <dd class={["text-3xl font-jersey10 text-foreground mt-1", info[:class]]}>
          {render_slot(info)}
        </dd>
      </div>
    </dl>
    """
  end
end
