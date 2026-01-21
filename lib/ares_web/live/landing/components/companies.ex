defmodule AresWeb.Components.Companies do
  @moduledoc """
  Companies component with company listings.
  """
  use Phoenix.Component

  attr :companies, :list, required: true

  def companies(assigns) do
    ~H"""
    <div class="w-full space-y-2 font-inter">
      <div class="relative border border-white px-6 pb-8 pt-8 w-full">
        <h3 class="absolute left-4 top-0 -translate-y-1/2 rounded-full border border-current bg-black px-4 py-1 uppercase tracking-tight text-xs">
          Sponsor
        </h3>
        <ul
          id="companies-listing"
          class="flex flex-row justify-center items-center gap-16 sm:gap-8 sm:h-32"
        >
          <li :for={company <- @companies} class="">
            <p :if={!company.logo} class="font-semibold text-2xl">{company.name}</p>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
