defmodule AresWeb.Components.VenueMap do
  @moduledoc """
  Stylized static map of the venue (UMinho Sports Complex, Gualtar), linking
  out to Google Maps. The image is rendered from OpenStreetMap data.
  """
  use Phoenix.Component

  attr :class, :any, default: nil

  def venue_map(assigns) do
    ~H"""
    <a
      href="https://maps.google.com/?q=Complexo Desportivo da Universidade do Minho, Braga"
      target="_blank"
      rel="noopener noreferrer"
      class={["group relative overflow-hidden block h-96 bg-background border border-line", @class]}
    >
      <img
        src="/images/landing/venue-map.svg"
        alt="Map of the University of Minho Gualtar campus, highlighting the Sports Complex"
        class="absolute inset-0 size-full object-cover"
        loading="lazy"
      />

      <%!-- The venue: a white pixel with a cursor-like blink, and its name. --%>
      <span class="absolute left-1/2 top-1/2 -translate-1/2 pointer-events-none">
        <span class="block size-4 bg-foreground pixel-blink"></span>
        <span class="absolute top-full left-1/2 -translate-x-1/2 mt-2 sm:top-1/2 sm:left-full sm:translate-x-0 sm:-translate-y-1/2 sm:mt-0 sm:ml-3 whitespace-nowrap font-jersey10 text-xl leading-none text-foreground">
          <span class="hidden sm:inline">&lt;-</span> Sports Complex
        </span>
      </span>

      <span class="absolute top-4 left-4 font-jersey10 text-2xl text-foreground leading-none">
        41.5617° N · 8.3950° W
      </span>
      <span class="absolute top-12 left-4 sm:top-auto sm:bottom-4 text-sm text-muted">
        © OpenStreetMap contributors
      </span>
      <span class="absolute bottom-4 right-4 pixel-corners font-jersey10 text-2xl bg-foreground text-background px-4 py-1 group-hover:bg-muted transition-colors">
        Open in maps
      </span>
    </a>
    """
  end
end
