defmodule AresWeb.Components.Card do
  @moduledoc """
  Bordered content container. Pass padding and layout through `class`.
  """
  use Phoenix.Component

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={["border border-line", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
