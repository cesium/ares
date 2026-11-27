defmodule AresWeb.Components.Footer do
  @moduledoc """
  Footer component with social links.
  """
  use Phoenix.Component

  @doc """
  Renders the footer component with social links.
  """
  def footer(assigns) do
    ~H"""
    <footer class="flex flex-col gap-6 bg-background page-px py-8">
      <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-6">
        <div class="flex flex-col">
          <span class="uppercase font-jersey10 text-sm text-foreground">hackathon</span>
          <span class="uppercase font-jersey10 tracking-wide leading-none text-3xl">bugsbyte</span>
        </div>
        <div class="flex items-center gap-4">
          <a
            href="https://www.instagram.com/bugs.byte/"
            target="_blank"
            rel="noopener noreferrer"
            class="hover:opacity-80 transition-opacity"
            aria-label="Instagram"
          >
            <img src="/images/brand/instagram.svg" alt="Instagram" class="w-6 h-6" />
          </a>
          <a
            href="https://cesium.di.uminho.pt"
            target="_blank"
            rel="noopener noreferrer"
            class="hover:opacity-80 transition-opacity"
            aria-label="CeSIUM"
          >
            <img src="/images/brand/cesium.svg" alt="CeSIUM" class="w-6 h-6" />
          </a>
        </div>
      </div>

      <div class="pt-6 border-t border-line text-sm text-muted text-right">
        2027
      </div>
    </footer>
    """
  end
end
