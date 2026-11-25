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
      class={[
        "group relative overflow-hidden block h-96 bg-background border border-line hover:border-primary transition-colors",
        @class
      ]}
    >
      <img
        src="/images/landing/venue-map.svg"
        alt="Map of the University of Minho Gualtar campus, highlighting the Sports Complex"
        class="absolute inset-0 size-full object-cover"
        loading="lazy"
      />

      <span class="absolute left-1/2 top-1/2 -translate-1/2 size-6 pointer-events-none">
        <span class="absolute inset-0 rounded-full bg-primary animate-ping"></span>
        <span class="absolute inset-1.5 rounded-full bg-foreground ring-4 ring-primary"></span>
      </span>

      <span class="absolute top-4 left-4 font-jersey10 text-2xl text-primary leading-none">
        41.5617° N · 8.3950° W
      </span>
      <span class="absolute bottom-4 left-4 uppercase text-sm text-muted">
        © OpenStreetMap contributors
      </span>
      <span class="absolute bottom-4 right-4 font-jersey10 text-2xl uppercase bg-primary text-background px-3 py-1 group-hover:bg-foreground transition-colors">
        Open in maps ↗
      </span>
    </a>
    """
  end
end
