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
        <.link navigate="/" class="flex items-center gap-3">
          <img src="/images/brand/gub-logo-white.png" alt="" class="h-10 w-auto" />
          <span class="font-resegrg uppercase text-2xl leading-none">BugsByte</span>
        </.link>
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
