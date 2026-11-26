defmodule Ares.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "projects" do
    field :name, :string
    field :description, :string
    field :repo_url, :string
    field :demo_url, :string
    field :submitted_at, :utc_datetime
    belongs_to :team, Ares.Teams.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:team_id, :name, :description, :repo_url, :demo_url, :submitted_at])
    |> validate_required([:team_id, :name])
    |> validate_change(:repo_url, &validate_url/2)
    |> validate_change(:demo_url, &validate_url/2)
    |> unique_constraint(:team_id)
  end

  defp validate_url(field, url) do
    uri = URI.parse(url)
    if uri.scheme in ["http", "https"] && uri.host, do: [], else: [{field, "must be a valid URL"}]
  end
end
