defmodule ExMoexLive.BoardGroups do
  @moduledoc """
  The BoardGroups context.
  """

  import Ecto.Query, warn: false
  alias ExMoexLive.Repo

  alias ExMoexLive.BoardGroups.BoardGroup

  def import(data) do
    columns = data["columns"]
    rows = data["data"]
    Enum.map(rows, fn(row) ->
      record = Enum.zip(columns, row) |> Enum.into(%{})
      changeset = BoardGroup.changeset(%BoardGroup{}, record)
      Repo.insert!(changeset, on_conflict: :nothing)
    end)
  end

  @doc """
  Returns the list of board_groups.

  ## Examples

      iex> list_board_groups()
      [%BoardGroup{}, ...]

  """
  def list_board_groups do
    Repo.all(BoardGroup)
  end

  @doc """
  Gets a single board_group.

  Raises `Ecto.NoResultsError` if the Board group does not exist.

  ## Examples

      iex> get_board_group!(123)
      %BoardGroup{}

      iex> get_board_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_group!(id), do: Repo.get!(BoardGroup, id)

  @doc """
  Creates a board_group.

  ## Examples

      iex> create_board_group(%{field: value})
      {:ok, %BoardGroup{}}

      iex> create_board_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board_group(attrs \\ %{}) do
    %BoardGroup{}
    |> BoardGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board_group.

  ## Examples

      iex> update_board_group(board_group, %{field: new_value})
      {:ok, %BoardGroup{}}

      iex> update_board_group(board_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board_group(%BoardGroup{} = board_group, attrs) do
    board_group
    |> BoardGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board_group.

  ## Examples

      iex> delete_board_group(board_group)
      {:ok, %BoardGroup{}}

      iex> delete_board_group(board_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board_group(%BoardGroup{} = board_group) do
    Repo.delete(board_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board_group changes.

  ## Examples

      iex> change_board_group(board_group)
      %Ecto.Changeset{data: %BoardGroup{}}

  """
  def change_board_group(%BoardGroup{} = board_group, attrs \\ %{}) do
    BoardGroup.changeset(board_group, attrs)
  end
end
