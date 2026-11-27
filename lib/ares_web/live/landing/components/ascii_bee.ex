defmodule AresWeb.Components.AsciiBee do
  @moduledoc """
  Hero scene: the venue's sports hall full of hackers, drawn in dim ASCII
  (`crowd.txt`), with the edition's bee (`bee.txt`) flying through it as the
  only coloured thing. Both are read at compile time; swap `bee.txt` for
  next year's insect.

  On load the scene builds itself: characters pop in at random, from the
  middle of the bee outwards. After that, bee
  characters near the mouse cursor change (see `ALT` in the hook), hold for
  a moment, then settle back.
  """
  use Phoenix.Component

  alias AresWeb.Components.Ascii

  @crowd_path Path.join(__DIR__, "crowd.txt")
  @bee_path Path.join(__DIR__, "bee.txt")
  @external_resource @crowd_path
  @external_resource @bee_path

  # Where the bee's top-left corner sits in the crowd grid (row, column).
  @bee_row 12
  @bee_col 42

  crowd = Ascii.read!(@crowd_path)
  bee = @bee_path |> Ascii.read!() |> String.split("\n")

  # The bee on the same grid as the crowd, so both layers line up.
  bee_layer =
    List.duplicate("", @bee_row) ++
      Enum.map(bee, &(String.duplicate(" ", @bee_col) <> &1)) ++
      List.duplicate("", length(String.split(crowd, "\n")) - @bee_row - length(bee))

  @bee Enum.join(bee_layer, "\n")
  # Clear the crowd behind the bee, so the bee reads cleanly.
  @crowd Ascii.cut_out(crowd, @bee)
  @style Ascii.scene_style(@crowd)

  # Grid position the build-up starts from: the middle of the bee.
  @origin {@bee_row + 20, @bee_col + 57}

  attr :id, :string, default: "ascii-hero"
  attr :class, :any, default: nil

  def ascii_bee(assigns) do
    {row, col} = @origin
    assigns = assign(assigns, crowd: @crowd, bee: @bee, style: @style, row: row, col: col)

    ~H"""
    <div
      id={@id}
      phx-hook=".AsciiBee"
      phx-update="ignore"
      data-build
      data-origin-row={@row}
      data-origin-col={@col}
      class={["ascii-scene", @class]}
      style={@style}
      aria-hidden="true"
    >
      <pre class="text-line">{@crowd}</pre>
      <pre class="text-secondary">{@bee}</pre>
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".AsciiBee">
      // Build-up: characters pop in one by one, in place, scattered at random
      // but on average earlier near the middle of the bee than far from it.
      const SPREAD = 1200 // ms of delay added by distance from the middle
      const JITTER = 1000 // ms of random delay per cell; large, so there's no visible front

      // Hover: bee characters near the cursor change, hold, then settle back.
      const ALT = "|~"
      const RADIUS = 6 // in character columns
      const HOLD = 500 // ms a cell stays changed after the cursor leaves it
      const STAGGER = 250 // ms of random per-cell delay, so cells don't flip in unison

      const grid = (pre) => {
        const lines = pre.textContent.replace(/\n$/, "").split("\n")
        const cols = Math.max(...lines.map((l) => l.length))
        return { pre, rows: lines.length, cols, art: lines.map((l) => l.padEnd(cols)), last: null }
      }

      const draw = (layer, glyph) => {
        let out = ""
        for (let y = 0; y < layer.rows; y++) {
          for (let x = 0; x < layer.cols; x++) out += glyph(y * layer.cols + x, layer.art[y][x])
          out += "\n"
        }
        // Lines keep their trailing spaces: the scene centres the art by its
        // width, so trimming them would shift the art while it builds.
        if (out !== layer.last) layer.pre.textContent = layer.last = out
      }

      export default {
        mounted() {
          const pres = [...this.el.querySelectorAll("pre")]
          // CSS hides the art until now (see [data-build] in app.css)
          if (matchMedia("(prefers-reduced-motion: reduce)").matches) {
            for (const pre of pres) pre.style.visibility = "visible"
            return
          }

          const [crowd, bee] = pres.map(grid)
          const oy = +this.el.dataset.originRow
          const ox = +this.el.dataset.originCol
          // distance in em: a character is ~0.6em wide and 1em tall
          const far = Math.hypot(Math.max(ox, crowd.cols - ox) * 0.6, Math.max(oy, crowd.rows - oy))

          for (const layer of [crowd, bee]) {
            layer.start = Float32Array.from({ length: layer.rows * layer.cols }, (_, i) => {
              const y = (i / layer.cols) | 0
              const x = i % layer.cols
              return (Math.hypot((x - ox) * 0.6, y - oy) / far) * SPREAD + Math.random() * JITTER
            })
          }

          const t0 = performance.now()
          const built = (layer, i, ch, now) => {
            return now - t0 < layer.start[i] ? " " : ch
          }

          const build = () => {
            const now = performance.now()
            draw(crowd, (i, ch) => built(crowd, i, ch, now))
            draw(bee, (i, ch) => built(bee, i, ch, now))
            for (const pre of pres) pre.style.visibility = "visible"
            if (now - t0 < SPREAD + JITTER) {
              this.frame = requestAnimationFrame(build)
            } else {
              this.frame = null // hover only starts redrawing when no frame is pending
              this.hover(bee)
            }
          }
          build()
        },

        hover(bee) {
          const n = bee.rows * bee.cols
          // Each cell gets one fixed alternative character and delay, so a cell
          // changes once and holds instead of flickering.
          const alt = Array.from({ length: n }, () => ALT[(Math.random() * ALT.length) | 0])
          const delay = Float32Array.from({ length: n }, () => Math.random() * STAGGER)
          const since = new Float64Array(n) // when the cursor first reached the cell
          const until = new Float64Array(n) // when the cell reverts

          const render = () => {
            const now = performance.now()
            let active = false
            draw(bee, (i, ch) => {
              if (ch === " " || now >= until[i] + delay[i]) return ch
              active = true
              return now >= since[i] + delay[i] ? alt[i] : ch
            })
            this.frame = active ? requestAnimationFrame(render) : null
          }

          this.onMove = (e) => {
            const now = performance.now()
            const rect = bee.pre.getBoundingClientRect()
            const cx = ((e.clientX - rect.left) / rect.width) * bee.cols
            const cy = ((e.clientY - rect.top) / rect.height) * bee.rows
            // cells are ~2x taller than wide, so scale y to keep the area round
            const ry = Math.ceil(RADIUS / 2)
            for (let y = Math.max(0, Math.floor(cy - ry)); y <= Math.min(bee.rows - 1, cy + ry); y++) {
              for (let x = Math.max(0, Math.floor(cx - RADIUS)); x <= Math.min(bee.cols - 1, cx + RADIUS); x++) {
                const d = Math.hypot(x - cx, (y - cy) * 2) / RADIUS
                if (d >= 1) continue
                const i = y * bee.cols + x
                if (now >= until[i] + delay[i]) since[i] = now
                // closer cells hold longer, so the edge fades out gradually
                until[i] = Math.max(until[i], now + HOLD * (1 - d))
              }
            }
            if (!this.frame) render()
          }

          window.addEventListener("mousemove", this.onMove)
        },

        destroyed() {
          cancelAnimationFrame(this.frame)
          if (this.onMove) window.removeEventListener("mousemove", this.onMove)
        }
      }
    </script>
    """
  end
end
