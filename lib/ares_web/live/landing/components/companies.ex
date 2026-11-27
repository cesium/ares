defmodule AresWeb.Components.Companies do
  @moduledoc """
  A wall of company logos (sponsors and partners): equal cells on a hairline
  grid, logos in white so the wall stays one colour. A company without a
  logo shows its name.
  """
  alias Ares.Uploaders
  use Phoenix.Component

  attr :companies, :list, required: true
  attr :id, :string, default: "companies-listing"

  def companies(assigns) do
    ~H"""
    <ul id={@id} class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 pt-px pl-px">
      <%!-- Overlapping borders make one hairline between neighbours. --%>
      <li :for={company <- @companies} class="-mt-px -ml-px border border-line">
        <a
          href={company.url}
          target="_blank"
          rel="noopener noreferrer"
          class="group flex h-32 items-center justify-center p-6 text-center"
        >
          <span
            :if={!company.logo}
            class="font-jersey10 text-2xl leading-none text-muted group-hover:text-foreground transition-colors"
          >
            {company.name}
          </span>
          <img
            :if={company.logo}
            src={Uploaders.Company.url({company.logo, company}, :original, signed: true)}
            alt={company.name}
            class="max-h-12 w-auto object-contain brightness-0 invert opacity-70 group-hover:opacity-100 transition-opacity"
          />
        </a>
      </li>
    </ul>
    """
  end
end
