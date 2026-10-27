defmodule AresWeb.LandingLive.Home do
  use AresWeb, :landing_view

  alias Ares.Companies
  import AresWeb.Components.{Companies, SquigglyEffect, LandingSection}

  @impl true
  def mount(_params, _session, socket) do
    companies = Companies.list_companies()
    sponsors = Enum.filter(companies, fn c -> c.type == :sponsor end)
    partners = Enum.filter(companies, fn c -> c.type == :partner end)

    socket =
      socket
      |> assign(:sponsors, sponsors)
      |> assign(:partners, partners)
      |> assign(:supporters, [])
      |> assign(:user, nil)

    {:ok, socket}
  end

  @doc """
  Full-bleed "by the numbers" band: one green panel per stat, filling the viewport.
  """
  attr :items, :list, required: true

  def stat_band(assigns) do
    gradient =
      assigns.items
      |> Enum.with_index()
      |> Enum.map(fn {_item, i} -> stat_bg(i) end)
      |> Enum.reverse()
      |> Enum.join(", ")

    assigns = assign(assigns, :gradient, gradient)

    ~H"""
    <div class="relative">
      <div
        class="stat-band-glow absolute -inset-8 blur-2xl opacity-80"
        style={"--stat-gradient: #{@gradient}"}
      >
      </div>
      <section
        class="stat-band relative grid grid-cols-1 text-foreground font-inter"
        style={"--stat-cols: #{length(@items)}; --stat-gradient: #{@gradient}"}
      >
        <div
          :for={{_value, _label} <- @items}
          class="flex flex-col items-center justify-center gap-2 px-8 py-3 text-center"
        >
        </div>
      </section>
    </div>
    """
  end

  defp stat_bg(i), do: Enum.at(~w(#66B22E #4C8A22 #35631A), rem(i, 3))

  @doc """
  A small stack of overlapping, rotated photos. Hover/focus brings one to the front.
  """
  attr :images, :list, required: true

  def photo_stack(assigns) do
    ~H"""
    <div class="relative w-full max-w-2xl aspect-[4/3]">
      <img
        :for={{src, i} <- Enum.with_index(@images)}
        src={src}
        alt=""
        tabindex="0"
        class={[
          "absolute w-2/3 aspect-[4/3] object-cover shadow-2xl border-4 border-background cursor-pointer outline-none transition-transform duration-300 ease-out hover:z-10 hover:scale-105 focus:z-10 focus:scale-105",
          photo_position(i)
        ]}
      />
    </div>
    """
  end

  defp photo_position(i) do
    Enum.at(
      [
        "top-2 left-2 rotate-[-6deg]",
        "top-0 right-2 rotate-[5deg]",
        "bottom-2 left-1/4 rotate-[-2deg]"
      ],
      rem(i, 3)
    )
  end
end
