defmodule AresWeb.Components.SquigglyEffect do
  @moduledoc """
  SVG filter component used to apply animated squiggly distortion effects.
  """
  use Phoenix.Component

  attr :id, :string, default: "squiggly-filters"
  attr :class, :string, default: "absolute"

  def squiggly_effect(assigns) do
    ~H"""
    <svg width="0" height="0" id={@id} class={@class}>
      <defs>
        <filter id="melt-flow-slow">
          <feTurbulence
            type="fractalNoise"
            baseFrequency="0.008 0.012"
            numOctaves="5"
            result="turbulence"
          >
            <animate
              attributeName="seed"
              from="1"
              to="6000"
              dur="4220s"
              repeatCount="indefinite"
            />
          </feTurbulence>

          <feDisplacementMap
            in="SourceGraphic"
            in2="turbulence"
            scale="18"
            xChannelSelector="R"
            yChannelSelector="G"
          />

          <feGaussianBlur stdDeviation="0.4" />
        </filter>
        <filter id="melt-flow-medium">
          <feTurbulence
            type="fractalNoise"
            baseFrequency="0.008 0.012"
            numOctaves="5"
            result="turbulence"
          >
            <animate
              attributeName="seed"
              from="1"
              to="6000"
              dur="1220s"
              repeatCount="indefinite"
            />
          </feTurbulence>

          <feDisplacementMap
            in="SourceGraphic"
            in2="turbulence"
            scale="18"
            xChannelSelector="R"
            yChannelSelector="G"
          />

          <feGaussianBlur stdDeviation="0.4" />
        </filter>
        <filter id="melt-flow-fast">
          <feTurbulence
            type="fractalNoise"
            baseFrequency="0.008 0.012"
            numOctaves="5"
            result="turbulence"
          >
            <animate
              attributeName="seed"
              from="1"
              to="6000"
              dur="720s"
              repeatCount="indefinite"
            />
          </feTurbulence>

          <feDisplacementMap
            in="SourceGraphic"
            in2="turbulence"
            scale="18"
            xChannelSelector="R"
            yChannelSelector="G"
          />

          <feGaussianBlur stdDeviation="0.4" />
        </filter>
      </defs>
    </svg>
    """
  end
end
