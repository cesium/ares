defmodule AresWeb.Components.Navbar do
  @moduledoc """
  Navigation component with mobile and desktop layouts.
  """
  use Phoenix.Component

  @doc """
  Renders the navigation header with mobile menu support.
  """
  attr :fixed, :boolean, default: false
  attr :user, :map, default: nil

  def navbar(assigns) do
    ~H"""
    <header
      id="page-header"
      class={[
        "z-50 flex w-full items-center justify-between border-b border-transparent px-4 sm:px-6 md:px-8 py-3 sm:py-4 text-white",
        if(@fixed,
          do: "fixed-header fixed top-0 bg-black backdrop-blur-md shadow-lg",
          else: "absolute bottom-0"
        )
      ]}
      phx-hook="MobileNavigation"
    >
      <a class="flex items-center gap-2 sm:gap-3 hover:text-pink" href="/">
        <img src="/images/cesium.svg" alt="Cesium" class="object-fill w-7 h-7 sm:w-8 sm:h-8" />
        <span class="sm:hidden text-white font-semibold text-base sm:text-lg">CeSIUM</span>
      </a>
      <div>
        <div class="flex items-center gap-4 sm:gap-6">
          <nav class="hidden sm:block">
            <ul class="flex items-center gap-4 lg:gap-6">
              <li>
                <a
                  class="text-sm hover:text-pink transition-colors"
                  target="_blank"
                  href="images/docs/SurvivalGuideBugsByte2025.pdf"
                >
                  Survival Guide
                </a>
              </li>
              <li>
                <a
                  class="text-sm hover:text-pink transition-colors"
                  href="images/docs/RegulamentoBugsByte2025.pdf"
                >
                  Regulation
                </a>
              </li>
              <li>
                <a class="text-sm hover:text-pink transition-colors" href="/faqs">
                  FAQs
                </a>
              </li>
              <li>
                <a
                  class="text-sm hover:text-pink transition-colors"
                  href="https://2024.bugsbyte.org/"
                >
                  Previous edition
                </a>
              </li>
              <li>
                <a
                  class="text-sm hover:text-pink transition-colors"
                  target="_black"
                  href="/team-formation"
                >
                  Teams
                </a>
              </li>
              <%= if @user && @user.is_admin do %>
                <li>
                  <a
                    class="text-sm hover:text-pink transition-colors text-white"
                    href="/admin"
                  >
                    Admin
                  </a>
                </li>
              <% end %>
              <li class="relative">
                <%= if @user do %>
                  <button
                    onclick="document.getElementById('profile-menu').classList.toggle('hidden')"
                    class="w-10 h-10 cursor-pointer rounded-full bg-gradient-to-br from-darkest-pink to-pink flex items-center justify-center text-white font-semibold hover:shadow-lg transition-all"
                    title={@user.name}
                  >
                    {String.first(@user.name)}
                  </button>
                  <div
                    id="profile-menu"
                    class={[
                      "hidden absolute right-0 w-48 bg-gray-100 rounded-lg shadow-xl ring-1 ring-gray-800 z-50 profile-menu-dropdown"
                    ]}
                  >
                    <a
                      href="/profile"
                      class="block px-4 py-2 text-sm text-black hover:bg-gray-300 rounded-t-lg transition-colors"
                    >
                      View Profile
                    </a>
                    <form
                      action="/logout"
                      method="post"
                      class="border-t border-gray-700"
                      onsubmit="return confirm('Are you sure you want to logout?');"
                    >
                      <button
                        type="submit"
                        class="w-full text-left px-4 py-2 text-sm text-black hover:text-pink rounded-b-lg transition-colors cursor-pointer"
                      >
                        Logout
                      </button>
                    </form>
                  </div>
                <% else %>
                  <a
                    href="/register"
                    class="rounded-full px-2.5 py-1 text-xs font-semibold text-white shadow-sm ring-1 ring-inset ring-white hover:ring-pink"
                  >
                    Register
                  </a>
                <% end %>
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
      </div>
    </header>

    <div
      id="menu-modal"
      class="modal hidden fixed inset-0 bg-black px-4 sm:px-8 py-4 text-white z-[100]"
      aria-hidden="true"
    >
      <div class="space-y-4 w-full h-full" role="dialog" aria-modal="true">
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
              <%= if @user do %>
                <a
                  href="/profile"
                  class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-pink transition-colors"
                  title={@user.name}
                >
                  Profile
                </a>
              <% else %>
                <a
                  class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-pink transition-colors"
                  href="/register"
                >
                  Register
                </a>
              <% end %>
            </li>
            <%= if @user do %>
              <li>
                <form
                  action="/logout"
                  method="post"
                  onsubmit="return confirm('Are you sure you want to logout?');"
                >
                  <button
                    type="submit"
                    class="block w-full py-3 sm:py-4 text-center text-lg sm:text-xl text-red-400 hover:text-red-300 transition-colors"
                  >
                    Logout
                  </button>
                </form>
              </li>
            <% end %>
            <li>
              <a
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-pink transition-colors"
                href="images/docs/SurvivalGuideBugsByte2025.pdf"
              >
                Survival Guide
              </a>
            </li>
            <li>
              <a
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-pink transition-colors"
                href="images/docs/RegulamentoBugsByte2025.pdf"
              >
                Regulation
              </a>
            </li>
            <li>
              <a
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-pink transition-colors"
                href="/faqs"
              >
                FAQs
              </a>
            </li>
            <li>
              <a
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-pink transition-colors"
                href="https://2024.bugsbyte.org/"
              >
                Previous edition
              </a>
            </li>
            <li>
              <a
                class="block py-3 sm:py-4 text-center text-lg sm:text-xl hover:text-pink transition-colors"
                href="/team-formation"
              >
                Team formation
              </a>
            </li>
            <%= if @user && @user.is_admin do %>
              <li>
                <a
                  class="block py-3 sm:py-4 text-center text-lg sm:text-xl text-pink font-bold hover:text-darkest-pink transition-colors"
                  href="/admin"
                >
                  Admin Dashboard
                </a>
              </li>
            <% end %>
          </ul>
        </nav>
      </div>
    </div>
    """
  end
end
