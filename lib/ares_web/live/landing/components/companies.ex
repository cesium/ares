defmodule AresWeb.Components.Companies do
  @moduledoc """
  Renders a row of company logos (used for both sponsors and partners).
  """
  alias Ares.Uploaders
  use Phoenix.Component

  attr :companies, :list, required: true
  attr :id, :string, default: "companies-listing"

  def companies(assigns) do
    ~H"""
    <ul
      id={@id}
      class="flex flex-col md:flex-row justify-evenly items-center gap-24 md:gap-8 md:h-32 font-inter"
    >
      <li :for={company <- @companies}>
        <a href={company.url} target="_blank" rel="noopener noreferrer">
          <p :if={!company.logo} class="font-semibold text-2xl">{company.name}</p>
          <img
            :if={company.logo}
            src={Uploaders.Company.url({company.logo, company}, :original, signed: true)}
            alt={company.name}
            class="h-16 sm:h-12 object-contain"
          />
        </a>
      </li>
    </ul>
    """
  end
end
