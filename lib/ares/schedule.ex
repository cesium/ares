defmodule Ares.Schedule do
  @moduledoc """
  The Schedule context.
  """

  import Ecto.Query, warn: false
  alias Ares.Repo

  alias Ares.Schedule.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Activity
    |> order_by([a], asc: a.date, asc: a.time)
    |> Repo.all()
  end

  @doc """
  Returns the activities of a given day, ordered by time.
  If `types` is not empty, only activities of those types are returned.

  ## Examples

      iex> list_daily_activities(~D[2026-11-19], [:food])
      [%Activity{}, ...]

  """
  def list_daily_activities(day, types \\ []) do
    Activity
    |> where([a], a.date == ^day)
    |> then(fn q -> if types == [], do: q, else: where(q, [a], a.type in ^types) end)
    |> order_by([a], asc: a.time)
    |> Repo.all()
  end

  @doc """
  Returns the distinct days that have activities, in ascending order.

  ## Examples

      iex> list_days()
      [~D[2026-11-19], ~D[2026-11-20]]

  """
  def list_days do
    Activity
    |> select([a], a.date)
    |> distinct(true)
    |> order_by([a], asc: a.date)
    |> Repo.all()
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id), do: Repo.get!(Activity, id)

  @doc """
  Creates an activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end
end
