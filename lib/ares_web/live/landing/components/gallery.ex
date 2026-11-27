defmodule AresWeb.Components.Gallery do
  @moduledoc """
  A full-width strip of photos that loops sideways on its own and pauses on
  hover (see `.marquee` in app.css). Render it outside padded sections so it
  runs edge to edge.

  The strip is drawn twice, in sync: photos in ASCII (like the hero), and
  over them the real photos, visible only through a lens in the middle of
  the screen (`.gallery-lens`). Each photo develops as it passes the centre,
  on touch screens too.
  """
  use Phoenix.Component

  alias AresWeb.Components.Ascii

  # ASCII versions of the photos, keyed by file name without extension.
  # A photo without one is shown as is.
  @art_dir Path.join(__DIR__, "gallery")
  @art (for file <- File.ls!(@art_dir), Path.extname(file) == ".txt", into: %{} do
          path = Path.join(@art_dir, file)
          @external_resource path
          {Path.rootname(file), Ascii.read!(path)}
        end)

  attr :images, :list, required: true
  attr :class, :any, default: nil

  def gallery(assigns) do
    assigns = assign(assigns, :art, @art)

    ~H"""
    <div class={["marquee relative", @class]}>
      <.strip :let={src} images={@images}>
        <% art = @art[Path.basename(src, Path.extname(src))] %>
        <div :if={art} class="ascii-scene size-full" style={Ascii.scene_style(art)}>
          <pre class="text-subtle">{art}</pre>
        </div>
        <img :if={!art} src={src} alt="" loading="lazy" class="size-full object-cover" />
      </.strip>

      <div class="gallery-lens">
        <.strip :let={src} images={@images}>
          <img src={src} alt="" loading="lazy" decoding="async" class="size-full object-cover" />
        </.strip>
      </div>
    </div>
    """
  end

  attr :images, :list, required: true
  slot :inner_block, required: true

  # One looping row of tiles; both layers use it so they stay aligned.
  defp strip(assigns) do
    ~H"""
    <ul class="marquee-track flex w-max" aria-hidden="true">
      <%!-- Second copy only exists to make the loop seamless. --%>
      <li :for={src <- @images ++ @images} class="shrink-0 pr-4">
        <div class="h-56 sm:h-80 aspect-3/2 bg-background">
          {render_slot(@inner_block, src)}
        </div>
      </li>
    </ul>
    """
  end
end
