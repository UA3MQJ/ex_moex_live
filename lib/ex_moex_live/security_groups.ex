defmodule ExMoexLive.SecurityGroups do
  @moduledoc """
  The SecurityGroups context.
  """

  import Ecto.Query, warn: false
  alias ExMoexLive.Repo

  alias ExMoexLive.SecurityGroups.SecurityGroup

  def import(data) do
    columns = data["columns"]
    rows = data["data"]
    Enum.map(rows, fn(row) ->
      record = Enum.zip(columns, row) |> Enum.into(%{})
      changeset = SecurityGroup.changeset(%SecurityGroup{}, record)
      Repo.insert!(changeset, on_conflict: :nothing)
    end)
  end

  @doc """
  Returns the list of security_groups.

  ## Examples

      iex> list_security_groups()
      [%SecurityGroup{}, ...]

  """
  def list_security_groups do
    Repo.all(SecurityGroup)
  end

  @doc """
  Gets a single security_group.

  Raises `Ecto.NoResultsError` if the Security group does not exist.

  ## Examples

      iex> get_security_group!(123)
      %SecurityGroup{}

      iex> get_security_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_security_group!(id), do: Repo.get!(SecurityGroup, id)

  @doc """
  Creates a security_group.

  ## Examples

      iex> create_security_group(%{field: value})
      {:ok, %SecurityGroup{}}

      iex> create_security_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_security_group(attrs \\ %{}) do
    %SecurityGroup{}
    |> SecurityGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a security_group.

  ## Examples

      iex> update_security_group(security_group, %{field: new_value})
      {:ok, %SecurityGroup{}}

      iex> update_security_group(security_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_security_group(%SecurityGroup{} = security_group, attrs) do
    security_group
    |> SecurityGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a security_group.

  ## Examples

      iex> delete_security_group(security_group)
      {:ok, %SecurityGroup{}}

      iex> delete_security_group(security_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_security_group(%SecurityGroup{} = security_group) do
    Repo.delete(security_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking security_group changes.

  ## Examples

      iex> change_security_group(security_group)
      %Ecto.Changeset{data: %SecurityGroup{}}

  """
  def change_security_group(%SecurityGroup{} = security_group, attrs \\ %{}) do
    SecurityGroup.changeset(security_group, attrs)
  end
end
