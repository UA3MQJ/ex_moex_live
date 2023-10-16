defmodule ExMoexLive.SecurityTypes do
  @moduledoc """
  The SecurityTypes context.
  """

  import Ecto.Query, warn: false
  alias ExMoexLive.Repo

  alias ExMoexLive.SecurityTypes.SecurityType

  def import(data) do
    columns = data["columns"]
    rows = data["data"]
    Enum.map(rows, fn(row) ->
      record = Enum.zip(columns, row) |> Enum.into(%{})
      changeset = SecurityType.changeset(%SecurityType{}, record)
      Repo.insert!(changeset, on_conflict: :nothing)
    end)
  end

  @doc """
  Returns the list of security_types.

  ## Examples

      iex> list_security_types()
      [%SecurityType{}, ...]

  """
  def list_security_types do
    Repo.all(SecurityType)
  end

  @doc """
  Gets a single security_type.

  Raises `Ecto.NoResultsError` if the Security type does not exist.

  ## Examples

      iex> get_security_type!(123)
      %SecurityType{}

      iex> get_security_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_security_type!(id), do: Repo.get!(SecurityType, id)

  @doc """
  Creates a security_type.

  ## Examples

      iex> create_security_type(%{field: value})
      {:ok, %SecurityType{}}

      iex> create_security_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_security_type(attrs \\ %{}) do
    %SecurityType{}
    |> SecurityType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a security_type.

  ## Examples

      iex> update_security_type(security_type, %{field: new_value})
      {:ok, %SecurityType{}}

      iex> update_security_type(security_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_security_type(%SecurityType{} = security_type, attrs) do
    security_type
    |> SecurityType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a security_type.

  ## Examples

      iex> delete_security_type(security_type)
      {:ok, %SecurityType{}}

      iex> delete_security_type(security_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_security_type(%SecurityType{} = security_type) do
    Repo.delete(security_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking security_type changes.

  ## Examples

      iex> change_security_type(security_type)
      %Ecto.Changeset{data: %SecurityType{}}

  """
  def change_security_type(%SecurityType{} = security_type, attrs \\ %{}) do
    SecurityType.changeset(security_type, attrs)
  end
end
