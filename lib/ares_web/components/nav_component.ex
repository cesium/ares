defmodule AresWeb.NavComponent do
  @moduledoc """
  Navigation component with mobile and desktop layouts.
  """
  use Phoenix.Component

  @doc """
  Renders the navigation header with mobile menu support.
  """
  attr :fixed, :boolean, default: false

  def navbar(assigns) do
    ~H"""
    <header
      id="page-header"
      class={[
        "z-50 flex w-full items-center justify-between border-b border-transparent px-4 sm:px-6 md:px-8 py-3 sm:py-4 text-white",
        if(@fixed, do: "fixed top-0 bg-black backdrop-blur-md shadow-lg", else: "absolute bottom-0")
      ]}
      phx-hook="MobileNavigation"
    >
      <a class="flex items-center gap-2 sm:gap-3 hover:text-white" href="/">
        <img src="/images/cesium.svg" alt="Cesium" class="object-fill w-7 h-7 sm:w-8 sm:h-8" />
        <span class="sm:hidden text-white font-semibold text-base sm:text-lg">CeSIUM</span>
      </a>
      <div>
        <div class="flex items-center gap-4 sm:gap-6">
          <nav class="hidden sm:block">
            <ul class="flex items-center gap-4 lg:gap-6">
              <li>
                <a
                  class="text-sm hover:text-secondary transition-colors"
                  href="images/docs/SurvivalGuideAres2025.pdf"
                >
                  Survival Guide
                </a>
              </li>
              <li>
                <a
                  class="text-sm hover:text-secondary transition-colors"
                  href="images/docs/RegulamentoAres2025.pdf"
                >
                  Regulation
                </a>
              </li>
              <li>
                <a class="text-sm hover:text-secondary transition-colors" href="/faqs">
                  FAQs
                </a>
              </li>
              <li>
                <a
                  class="text-sm hover:text-secondary transition-colors"
                  href="https://2024.ares.org/"
                >
                  Previous edition
                </a>
              </li>
              <li>
                <a class="text-sm hover:text-secondary transition-colors" href="/team-formation">
                  Teams
                </a>
              </li>
              <li>
                <a
                  href="/register"
                  class="rounded-full px-2.5 py-1 text-xs font-semibold text-white shadow-sm ring-1 ring-inset ring-white hover:ring-secondary"
                >
                  Register
                </a>
              </li>
            </ul>
          </nav>
          <button
            id="open-nav-button"
            type="button"
            class="btn sm:hidden text-white bg-black bg-opacity-70 p-2 rounded hover:bg-opacity-90 border border-white border-opacity-30"
            aria-label="Navigation"
            onclick="document.getElementById('menu-modal').classList.toggle('hidden'); console.log('Menu toggled');"
          >
            <svg class="w-6 h-6 sm:w-8 sm:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h16M4 18h16"
              />
            </svg>
          </button>
        </div>
        <div
          id="menu-modal"
          class="modal hidden fixed inset-0 bg-black px-4 sm:px-8 py-4 text-white z-[100]"
          aria-hidden="true"
        >
          <div class="space-y-4" role="dialog" aria-modal="true">
            <header class="text-right">
              <button
                id="close-nav-button"
                type="button"
                class="btn text-white bg-black bg-opacity-70 p-2 rounded hover:bg-opacity-90 border border-white border-opacity-30"
                aria-label="Close navigation"
                onclick="document.getElementById('menu-modal').classList.add('hidden'); console.log('Menu closed');"
              >
                <svg
                  class="w-6 h-6 sm:w-8 sm:h-8"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </header>
            <a href="/" class="flex justify-center py-4">
              <img src="/images/cesium.svg" alt="Cesium" class="w-14 h-14 sm:w-16 sm:h-16" />
            </a>
            <nav>
              <ul class="flex flex-col space-y-2">
                <li>
                  <a
                    class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-secondary transition-colors"
                    href="/register"
                  >
                    Register
                  </a>
                </li>
                <li>
                  <a
                    class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-secondary transition-colors"
                    href="images/docs/SurvivalGuideAres2025.pdf"
                  >
                    Survival Guide
                  </a>
                </li>
                <li>
                  <a
                    class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-secondary transition-colors"
                    href="images/docs/RegulamentoAres2025.pdf"
                  >
                    Regulation
                  </a>
                </li>
                <li>
                  <a
                    class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-secondary transition-colors"
                    href="/faqs"
                  >
                    FAQs
                  </a>
                </li>
                <li>
                  <a
                    class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-secondary transition-colors"
                    href="https://2024.ares.org/"
                  >
                    Previous edition
                  </a>
                </li>
                <li>
                  <a
                    class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-secondary transition-colors"
                    href="/team-formation"
                  >
                    Team formation
                  </a>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
    </header>
    """
  end
end
