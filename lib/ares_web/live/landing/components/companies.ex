defmodule AresWeb.Components.Companies do
  @moduledoc """
  Companies component with company listings.
  """
  alias Ares.Uploaders
  use Phoenix.Component

  attr :sponsors, :list, required: true
  attr :partners, :list, required: true

  def companies(assigns) do
    ~H"""
    <div class="w-full space-y-16 font-inter">
      <div :if={@sponsors != []} class="relative border border-white px-6 py-12 sm:py-8 w-full">
        <h3 class="absolute left-4 top-0 -translate-y-1/2 rounded-full border border-current bg-black px-4 py-1 uppercase tracking-tight">
          Sponsors
        </h3>
        <ul
          id="companies-listing"
          class="flex flex-col md:flex-row justify-evenly items-center gap-24 md:gap-8 md:h-32"
        >
          <li :for={company <- @sponsors}>
            <a href={company.url} target="_blank" rel="noopener noreferrer">
              <p :if={!company.logo} class="font-semibold text-2xl">{company.name}</p>
              <img
                :if={company.logo}
                src={Uploaders.Company.url({company.logo, company}, :original)}
                alt={company.name}
                class="h-16 sm:h-12 object-contain"
              />
            </a>
          </li>
        </ul>
      </div>
      <div :if={@partners != []} class="relative border border-white px-6 pb-8 pt-8 w-full">
        <h3 class="absolute left-4 top-0 -translate-y-1/2 rounded-full border border-current bg-black px-4 py-1 uppercase tracking-tight">
          Partners
        </h3>
        <ul
          id="companies-listing"
          class="flex flex-col md:flex-row justify-evenly items-center gap-24 md:gap-8 md:h-32"
        >
          <li :for={company <- @partners}>
            <a href={company.url} target="_blank" rel="noopener noreferrer">
              <p :if={!company.logo} class="font-semibold text-2xl">{company.name}</p>
              <img
                :if={company.logo}
                src={Uploaders.Company.url({company.logo, company}, :original)}
                alt={company.name}
                class="h-16 sm:h-12 object-contain"
              />
            </a>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
