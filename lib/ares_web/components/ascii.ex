defmodule AresWeb.Components.Ascii do
  @moduledoc """
  Helpers for the site's ASCII art. Art is plain text files read at compile
  time; a scene is one or more layers on the same character grid, scaled
  by `.ascii-scene` in app.css.
  """

  @doc """
  Reads an art file, dropping trailing whitespace. Leading blank lines are
  kept: layers of one scene line up by row.
  """
  def read!(path) do
    path
    |> File.read!()
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map_join("\n", &String.trim_trailing/1)
  end

  @doc """
  Clears `back` wherever `front` draws, row by row from the first to the
  last character of `front`, so the front layer reads cleanly on top.
  Both are art on the same grid.
  """
  def cut_out(back, front) do
    back = String.split(back, "\n")
    front = String.split(front, "\n")
    width = back |> Enum.map(&String.length/1) |> Enum.max()

    back
    |> Enum.with_index()
    |> Enum.map_join("\n", fn {line, i} ->
      line = String.pad_trailing(line, width)

      case Regex.run(~r/\S/, Enum.at(front, i, ""), return: :index) do
        nil ->
          line

        [{first, _}] ->
          last = String.length(String.trim_trailing(Enum.at(front, i))) - 1

          String.slice(line, 0, first) <>
            String.duplicate(" ", last - first + 1) <> String.slice(line, (last + 1)..-1//1)
      end
    end)
  end

  @doc "The inline style `.ascii-scene` needs to size a grid of `art`'s dimensions."
  def scene_style(art) do
    lines = String.split(art, "\n")
    cols = lines |> Enum.map(&String.length/1) |> Enum.max()
    "--ascii-cols: #{cols}; --ascii-rows: #{length(lines)}"
  end
end
