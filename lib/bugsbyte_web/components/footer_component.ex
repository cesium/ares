defmodule BugsbyteWeb.FooterComponent do
  @moduledoc """
  Footer component with social links.
  """
  use Phoenix.Component

  @doc """
  Renders the footer component with social links.
  """
  def footer(assigns) do
    ~H"""
    <footer class="relative flex h-48 items-center justify-center">
      <div class="absolute inset-0 overflow-hidden">
        <img
          class="h-full w-full object-cover opacity-80"
          src="/images/footer-background.png"
          alt="Footer background"
        />
        <div class="absolute inset-0 bg-black/50"></div>
      </div>

      <div class="relative z-10">
        <ul class="flex items-center gap-6">
          <li>
            <a
              class="flex items-center justify-center rounded-full border-2 border-white text-white hover:bg-white hover:text-black transition-colors duration-300 w-14 h-14 sm:w-16 sm:h-16"
              href="mailto:geral@bugsbyte.org"
              title="BugsByte email"
            >
              <span class="sr-only">BugsByte email</span>
              <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/>
              </svg>
            </a>
          </li>

          <li>
            <a
              class="flex items-center justify-center rounded-full border-2 border-white text-white hover:bg-white hover:text-black transition-colors duration-300 w-14 h-14 sm:w-16 sm:h-16"
              href="https://www.instagram.com/bugs.byte/"
              target="_blank"
              rel="noreferrer noopener"
              title="BugsByte on Instagram"
            >
              <span class="sr-only">BugsByte on Instagram</span>
              <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M7.8 2h8.4C19.4 2 22 4.6 22 7.8v8.4a5.8 5.8 0 0 1-5.8 5.8H7.8C4.6 22 2 19.4 2 16.2V7.8A5.8 5.8 0 0 1 7.8 2m-.2 2A3.6 3.6 0 0 0 4 7.6v8.8C4 18.39 5.61 20 7.6 20h8.8a3.6 3.6 0 0 0 3.6-3.6V7.6C20 5.61 18.39 4 16.4 4H7.6m9.65 1.5a1.25 1.25 0 0 1 1.25 1.25A1.25 1.25 0 0 1 17.25 8 1.25 1.25 0 0 1 16 6.75a1.25 1.25 0 0 1 1.65-1.25M12 7a5 5 0 0 1 5 5 5 5 0 0 1-5 5 5 5 0 0 1-5-5 5 5 0 0 1 5-5m0 2a3 3 0 0 0-3 3 3 3 0 0 0 3 3 3 3 0 0 0 3-3 3 3 0 0 0-3-3z"/>
              </svg>
            </a>
          </li>
        </ul>
      </div>
    </footer>
    """
  end
end
