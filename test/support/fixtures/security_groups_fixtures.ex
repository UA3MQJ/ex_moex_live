defmodule ExMoexLive.SecurityGroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExMoexLive.SecurityGroups` context.
  """

  @doc """
  Generate a security_group.
  """
  def security_group_fixture(attrs \\ %{}) do
    {:ok, security_group} =
      attrs
      |> Enum.into(%{
        is_hidden: 42,
        name: "some name",
        title: "some title"
      })
      |> ExMoexLive.SecurityGroups.create_security_group()

    security_group
  end
end
