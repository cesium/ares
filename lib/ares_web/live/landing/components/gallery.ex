defmodule AresWeb.Components.Gallery do
  @moduledoc """
  A full-width strip of photos that loops sideways on its own and pauses on
  hover (see `.gallery-viewport` in app.css). Render it outside padded
  sections so it runs edge to edge.
  """
  use Phoenix.Component

  attr :images, :list, required: true
  attr :class, :any, default: nil

  def gallery(assigns) do
    ~H"""
    <div class={["gallery-viewport", @class]}>
      <ul class="gallery-track flex w-max">
        <%!-- Second copy only exists to make the loop seamless. --%>
        <li
          :for={{src, copy} <- for(copy <- [0, 1], src <- @images, do: {src, copy})}
          class="shrink-0 pr-4"
          aria-hidden={copy == 1 && "true"}
        >
          <img
            src={src}
            alt=""
            loading="lazy"
            decoding="async"
            class="h-56 sm:h-80 aspect-[3/2] object-cover"
          />
        </li>
      </ul>
    </div>
    """
  end
end
