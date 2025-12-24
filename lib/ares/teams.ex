defmodule Ares.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias Ares.Repo

  alias Ares.Accounts
  alias Ares.Teams.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Returns the list of public teams that aren't full or have already paid.

  ## Examples

      iex> list_available_teams()
      [%Team{}, ...]

  """
  def list_available_teams do
    Team
    |> where([t], t.public == true)
    |> where([t], t.payment_status == :none)
    |> join(:left, [t], m in assoc(t, :members))
    |> group_by([t, _m], t.id)
    |> having([_t, m], count(m.id) < 5)
    |> preload(:members)
    |> Repo.all()
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id) do
    Team
    |> Repo.get!(id)
    |> Repo.preload(:members)
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Registers a team.

  ## Examples

      iex> register_team(%{field: value})
      {:ok, %Team{}}

      iex> register_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_team(attrs) do
    %Team{}
    |> Team.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.registration_changeset(team, attrs)
  end

  def create_and_join_team(user, team_params) do
    code = generate_random_code()

    Repo.transaction(fn ->
      with {:ok, team} <-
             register_team(Map.put(team_params, "code", code) |> Map.put("leader_id", user.id)),
           {:ok, _user} <- Accounts.update_user_team(user, %{team_id: team.id}) do
        {:ok, team}
      else
        error -> Repo.rollback(error)
      end
    end)
  end

  defp generate_random_code do
    :crypto.strong_rand_bytes(4)
    |> Base.encode32(padding: false)
    |> binary_part(0, 6)
  end

  def add_user_to_team_by_code(user, code) do
    case Repo.get_by(Team, code: code) |> Repo.preload(:members) do
      nil ->
        {:error, :not_found}

      team ->
        if length(team.members) < 5 and team.payment_status == :none do
          Accounts.update_user_team(user, %{team_id: team.id})
        else
          {:error, :unavailable}
        end
    end
  end

  @doc """
  Marks a team as paid.

  ## Examples

      iex> mark_team_as_paid(team_id)
      {:ok, %Team{}}

      iex> mark_team_as_paid(invalid_team_id)
      {:error, %Ecto.Changeset{}}

  """
  def mark_team_as_paid(team_id) do
    update_team(get_team!(team_id), %{payment_status: :paid})
  end
end
