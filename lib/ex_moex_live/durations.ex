defmodule ExMoexLive.Durations do
  @moduledoc """
  The Durations context.
  """

  import Ecto.Query, warn: false
  alias ExMoexLive.Repo

  alias ExMoexLive.Durations.Duration

  def import(data) do
    columns = data["columns"]
    rows = data["data"]
    Enum.map(rows, fn(row) ->
      record = Enum.zip(columns, row) |> Enum.into(%{})
      changeset = Duration.changeset(%Duration{}, record)
      Repo.insert!(changeset, on_conflict: :nothing, returning: false)
    end)
  end

  @doc """
  Returns the list of durations.

  ## Examples

      iex> list_durations()
      [%Duration{}, ...]

  """
  def list_durations do
    Repo.all(Duration)
  end

  @doc """
  Gets a single duration.

  Raises `Ecto.NoResultsError` if the Duration does not exist.

  ## Examples

      iex> get_duration!(123)
      %Duration{}

      iex> get_duration!(456)
      ** (Ecto.NoResultsError)

  """
  def get_duration!(duration), do: Repo.get!(Duration, duration)

  @doc """
  Creates a duration.

  ## Examples

      iex> create_duration(%{field: value})
      {:ok, %Duration{}}

      iex> create_duration(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_duration(attrs \\ %{}) do
    %Duration{}
    |> Duration.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a duration.

  ## Examples

      iex> update_duration(duration, %{field: new_value})
      {:ok, %Duration{}}

      iex> update_duration(duration, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_duration(%Duration{} = duration, attrs) do
    duration
    |> Duration.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a duration.

  ## Examples

      iex> delete_duration(duration)
      {:ok, %Duration{}}

      iex> delete_duration(duration)
      {:error, %Ecto.Changeset{}}

  """
  def delete_duration(%Duration{} = duration) do
    Repo.delete(duration)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking duration changes.

  ## Examples

      iex> change_duration(duration)
      %Ecto.Changeset{data: %Duration{}}

  """
  def change_duration(%Duration{} = duration, attrs \\ %{}) do
    Duration.changeset(duration, attrs)
  end
end
