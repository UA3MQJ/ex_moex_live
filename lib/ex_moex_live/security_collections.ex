defmodule ExMoexLive.SecurityCollections do
  @moduledoc """
  The SecurityCollections context.
  """

  import Ecto.Query, warn: false
  alias ExMoexLive.Repo

  alias ExMoexLive.SecurityCollections.SecurityCollection

  def import(data) do
    columns = data["columns"]
    rows = data["data"]
    Enum.map(rows, fn(row) ->
      record = Enum.zip(columns, row) |> Enum.into(%{})
      changeset = SecurityCollection.changeset(%SecurityCollection{}, record)
      Repo.insert!(changeset, on_conflict: :nothing)
    end)
  end

  @doc """
  Returns the list of security_collections.

  ## Examples

      iex> list_security_collections()
      [%SecurityCollection{}, ...]

  """
  def list_security_collections do
    Repo.all(SecurityCollection)
  end

  @doc """
  Gets a single security_collection.

  Raises `Ecto.NoResultsError` if the Security collection does not exist.

  ## Examples

      iex> get_security_collection!(123)
      %SecurityCollection{}

      iex> get_security_collection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_security_collection!(id), do: Repo.get!(SecurityCollection, id)

  @doc """
  Creates a security_collection.

  ## Examples

      iex> create_security_collection(%{field: value})
      {:ok, %SecurityCollection{}}

      iex> create_security_collection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_security_collection(attrs \\ %{}) do
    %SecurityCollection{}
    |> SecurityCollection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a security_collection.

  ## Examples

      iex> update_security_collection(security_collection, %{field: new_value})
      {:ok, %SecurityCollection{}}

      iex> update_security_collection(security_collection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_security_collection(%SecurityCollection{} = security_collection, attrs) do
    security_collection
    |> SecurityCollection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a security_collection.

  ## Examples

      iex> delete_security_collection(security_collection)
      {:ok, %SecurityCollection{}}

      iex> delete_security_collection(security_collection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_security_collection(%SecurityCollection{} = security_collection) do
    Repo.delete(security_collection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking security_collection changes.

  ## Examples

      iex> change_security_collection(security_collection)
      %Ecto.Changeset{data: %SecurityCollection{}}

  """
  def change_security_collection(%SecurityCollection{} = security_collection, attrs \\ %{}) do
    SecurityCollection.changeset(security_collection, attrs)
  end
end
