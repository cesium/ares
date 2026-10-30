defmodule AresWeb.Components.Page do
  @moduledoc """
  Standard page chrome: canonical width and padding, a title, an optional
  subtitle and the page content.
  """
  use Phoenix.Component

  attr :title, :string, required: true
  slot :subtitle
  slot :inner_block, required: true

  def page(assigns) do
    ~H"""
    <div class="max-w-5xl mx-auto page-px pt-8 pb-8 sm:pb-12 md:pb-16">
      <div class="mb-8 sm:mb-12 md:mb-16">
        <h1 class="text-foreground text-5xl md:text-6xl lg:text-7xl font-vt323 mb-6 sm:mb-8 mt-16">
          {@title}
        </h1>
        <div :if={@subtitle != []} class="mb-6 sm:mb-8">
          <p class="text-foreground text-xl lg:text-2xl xl:text-3xl uppercase">
            {render_slot(@subtitle)}
          </p>
        </div>
      </div>

      {render_slot(@inner_block)}
    </div>
    """
  end
end
