defmodule AresWeb.Components.LandingSection do
  @moduledoc """
  Shared landing-page section chrome: canonical padding, black background, an
  accent heading and body content spanning the page width.
  """
  use Phoenix.Component

  attr :title, :string, required: true
  slot :inner_block, required: true
  slot :media

  def landing_section(assigns) do
    ~H"""
    <section class="page-px bg-black pt-16 sm:pt-12 md:pt-16 pb-16 sm:pb-12 md:pb-16">
      <div class={["grid gap-8", @media != [] && "lg:grid-cols-2 lg:items-center"]}>
        <div>
          <h2 class="font-vt323 text-white text-5xl md:text-6xl lg:text-7xl mb-2">
            {@title}
          </h2>

          {render_slot(@inner_block)}
        </div>

        <div :if={@media != []} class="flex items-center justify-center">
          {render_slot(@media)}
        </div>
      </div>
    </section>
    """
  end
end
