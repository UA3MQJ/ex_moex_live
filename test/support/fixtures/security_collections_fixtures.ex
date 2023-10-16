defmodule ExMoexLive.SecurityCollectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.SecurityCollections` context.
  """

  @doc """
  Generate a security_collection.
  """
  def security_collection_fixture(attrs \\ %{}) do
    {:ok, security_collection} =
      attrs
      |> Enum.into(%{
        name: "some name",
        security_group_id: 42,
        title: "some title"
      })
      |> ExMoexLive.SecurityCollections.create_security_collection()

    security_collection
  end
end
